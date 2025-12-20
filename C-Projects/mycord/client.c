#include <stdbool.h>
#include <stdio.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <string.h>
#include <errno.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include <pthread.h>
#include <signal.h>
#include <ctype.h>
#include <stdint.h>
#include <termios.h>
#include <sys/ioctl.h>

// --- Definitions ---

typedef enum MessageType {
    LOGIN = 0,
    LOGOUT = 1,
    MESSAGE_SEND = 2,
    MESSAGE_RECV = 10,
    DISCONNECT = 12,
    SYSTEM = 13
} message_type_t;

typedef struct __attribute__((packed)) Message {
    unsigned int type;
    unsigned int time;
    char username[32];
    char message[1024];
} message_t;

typedef struct Settings {
    struct sockaddr_in server;
    bool quiet;
    bool tui_mode; // Added TUI flag
    int socket_fd;
    bool running;
    char username[32];
} settings_t;

// --- TUI Globals ---
#define MAX_HISTORY 500
#define MAX_INPUT_LEN 1024

// Structure to store a formatted string for history
typedef struct {
    char text[1200]; // Pre-formatted text (including colors)
} history_entry_t;

static history_entry_t history[MAX_HISTORY];
static int history_count = 0;
static int scroll_offset = 0; // 0 = at bottom, >0 = scrolling back
static char input_buffer[MAX_INPUT_LEN] = {0};
static int input_len = 0;
static struct termios orig_termios; // To restore terminal settings
static pthread_mutex_t tui_mutex = PTHREAD_MUTEX_INITIALIZER;

static char* COLOR_RED = "\033[31m";
static char* COLOR_GRAY = "\033[90m";
static char* COLOR_RESET = "\033[0m";
static settings_t settings = {0};

// --- Helper Functions ---

// Get current terminal window size
void get_window_size(int *rows, int *cols) {
    struct winsize ws;
    if (ioctl(STDOUT_FILENO, TIOCGWINSZ, &ws) == -1 || ws.ws_col == 0) {
        *rows = 24; // Fallback
        *cols = 80;
    } else {
        *rows = ws.ws_row;
        *cols = ws.ws_col;
    }
}

// Disable Raw Mode (Restore terminal)
void disable_raw_mode() {
    if (settings.tui_mode) {
        tcsetattr(STDIN_FILENO, TCSAFLUSH, &orig_termios);
        printf("\033[?25h"); // Show cursor
    }
}

// Enable Raw Mode (Read byte-by-byte, no echo)
void enable_raw_mode() {
    tcgetattr(STDIN_FILENO, &orig_termios);
    atexit(disable_raw_mode);
    struct termios raw = orig_termios;
    // Turn off ECHO, ICANON (canonical mode), IEXTEN, ISIG (signals like Ctrl-C)
    raw.c_lflag &= ~(ECHO | ICANON | IEXTEN | ISIG);
    raw.c_cc[VMIN] = 0;  // Non-blocking read
    raw.c_cc[VTIME] = 1; // 100ms timeout
    tcsetattr(STDIN_FILENO, TCSAFLUSH, &raw);
    printf("\033[?25l"); // Hide cursor initially (we will place it manually)
}

// Add a formatted line to history
void add_to_history(const char* formatted_msg) {
    pthread_mutex_lock(&tui_mutex);
    if (history_count < MAX_HISTORY) {
        strncpy(history[history_count].text, formatted_msg, 1199);
        history_count++;
    } else {
        // Shift array left to make room (simple implementation)
        for (int i = 0; i < MAX_HISTORY - 1; i++) {
            history[i] = history[i+1];
        }
        strncpy(history[MAX_HISTORY-1].text, formatted_msg, 1199);
    }
    pthread_mutex_unlock(&tui_mutex);
}

// The core TUI drawing function
void draw_interface() {
    if (!settings.running) return;
    
    pthread_mutex_lock(&tui_mutex);
    
    int rows, cols;
    get_window_size(&rows, &cols);

    // 1. Hide Cursor & Move to Top Left
    printf("\033[?25l\033[H");

    // 2. Calculate drawing area
    int input_area_height = 1; // Just one line for input at bottom
    int message_area_height = rows - input_area_height - 1; // -1 for separator

    // 3. Draw Messages
    // We want to draw from (history_count - scroll_offset) upwards
    int start_index = history_count - scroll_offset - message_area_height;
    if (start_index < 0) start_index = 0;
    int end_index = history_count - scroll_offset;
    if (end_index > history_count) end_index = history_count;

    // Clear Screen Area (manually helps prevent flicker compared to \033[2J)
    // Actually, \033[2J is safer for full redraws.
    printf("\033[2J\033[H");

    int current_row = 1;
    for (int i = start_index; i < end_index; i++) {
        // Move to row
        printf("\033[%d;1H", current_row++);
        // Print message
        printf("%s", history[i].text);
    }

    // 4. Draw Separator Line
    printf("\033[%d;1H", rows - 1);
    for(int i=0; i<cols; i++) printf("-");

    // 5. Draw Input Line
    printf("\033[%d;1H", rows); // Go to last row
    printf("> %s", input_buffer);

    // 6. Position Cursor at end of input
    printf("\033[%d;%dH", rows, input_len + 3); // +3 for "> "
    
    // 7. Show Cursor
    printf("\033[?25h");
    fflush(stdout);
    
    pthread_mutex_unlock(&tui_mutex);
}

// --- Logic ---

int process_args(int argc, char *argv[]) {
    int index = 0;
    char help[] = "--help";
    char port[] = "--port";
    char ip[] = "--ip";
    char domain[] = "--domain";
    char quiet[] = "--quiet";
    char tui[] = "--tui"; // NEW FLAG
    bool ip_domain_given = false;

    while (index < argc) {
        if (strcmp(argv[index], help) == 0) {
            fprintf(stdout, "usage: ./client [-h] [--port PORT] [--ip IP] [--domain DOMAIN] [--quiet] [--tui]\n");
            return -1;
        } else if (strcmp(argv[index], port) == 0) {
            if (index + 1 < argc) {
                int port = atoi(argv[index + 1]);
                if ((port > 65535) || (port < 0)) return -1;
                settings.server.sin_port = htons((unsigned short)port);
                index++;
            } else return -1;
        } else if (strcmp(argv[index], ip) == 0) {
            if (ip_domain_given) return -1;
            if (index + 1 < argc) {
                if (!inet_aton(argv[index + 1], &(settings.server.sin_addr))) return -1;
                index++;
                ip_domain_given = true;
            } else return -1;
        } else if (strcmp(argv[index], domain) == 0) {
            if (ip_domain_given) return -1;
            if (index + 1 < argc) {
                struct hostent* host_info = gethostbyname(argv[index + 1]);
                if (!host_info || host_info->h_addrtype != AF_INET) return -1;
                settings.server.sin_addr = *(struct in_addr*)(host_info->h_addr_list[0]);
                index++;
                ip_domain_given = true;
            } else return -1;
        } else if (strcmp(argv[index], quiet) == 0) {
            settings.quiet = true;
        } else if (strcmp(argv[index], tui) == 0) {
            settings.tui_mode = true;
        }
        index++;
    }
    return 0;
}

int get_username() {
    FILE* username = popen("whoami", "r");
    if (username == NULL) return -1;
    char buffer[32];
    int index = 0;
    int c;
    while ((c = fgetc(username)) != EOF) {
        if (isprint(c)) {
            buffer[index++] = c;
            if (index == 31) break;
        }
    }
    pclose(username);
    if (index == 0) return -1;
    buffer[index] = '\0';
    strcpy(settings.username, buffer);
    return 0;
}

ssize_t perform_full_read(void *buf, size_t n) {
    int total = 0;
    while (total < n) {
        int curr = read(settings.socket_fd, buf + total, n - total);
        if (curr == 0) return 0;
        if (curr == -1) {
            if (errno == EINTR) continue;
            return -1;
        }
        total += curr;
    }
    return total;
}

void* receive_messages_thread(void* arg) {
    while (settings.running) {
        message_t recieved_message;
        ssize_t n = perform_full_read(&recieved_message, sizeof(recieved_message));
        
        if (n <= 0) {
            settings.running = false;
            break;  
        }

        recieved_message.type = ntohl(recieved_message.type);
        recieved_message.time = ntohl(recieved_message.time);   
        
        char msg_buffer[1200]; // Buffer to format string
        msg_buffer[0] = '\0';

        if (recieved_message.type == SYSTEM) {
            snprintf(msg_buffer, 1200, "%s[SYSTEM] %s%s", COLOR_GRAY, recieved_message.message, COLOR_RESET);
        } else if (recieved_message.type == DISCONNECT) {
            snprintf(msg_buffer, 1200, "%s[DISCONNECT] %s%s", COLOR_RED, recieved_message.message, COLOR_RESET);
            settings.running = false;
        } else if (recieved_message.type == MESSAGE_RECV) {
            time_t time = (time_t)recieved_message.time;
            struct tm* tm = localtime(&time);
            char time_str[64];
            strftime(time_str, 64, "%Y-%m-%d %H:%M:%S", tm); // Shorter time for TUI

            // Highlight check
            bool highlight = false;
            if (!settings.quiet) {
                char* found = strstr(recieved_message.message, "@");
                if (found && strncmp(found + 1, settings.username, strlen(settings.username)) == 0) {
                    highlight = true;
                }
            }
            
            if (highlight) {
                snprintf(msg_buffer, 1200, "%s %s: %s%s%s", time_str, recieved_message.username, COLOR_RED, recieved_message.message, COLOR_RESET);
            } else {
                snprintf(msg_buffer, 1200, "%s %s: %s", time_str, recieved_message.username, recieved_message.message);
            }
        }

        if (msg_buffer[0] != '\0') {
            if (settings.tui_mode) {
                // In TUI mode, update history and redraw
                add_to_history(msg_buffer);
                // Only redraw if user is looking at the bottom
                if (scroll_offset == 0) draw_interface();
            } else {
                // Standard STDOUT mode
                fprintf(stdout, "%s\n", msg_buffer);
            }
        }
        
        if (!settings.running) {
           break;
	}
    }
    return NULL;
}

void cleanup() {
    if (settings.tui_mode) disable_raw_mode();
    close(settings.socket_fd);
    settings.socket_fd = -1;
}

void handle_signal(int signal) {
    message_t logout_message;
    logout_message.type = LOGOUT;
    logout_message.type = htonl(logout_message.type);
    write(settings.socket_fd, &logout_message, sizeof(logout_message));
    cleanup();
    settings.running = false;
    exit(0);
}

int main(int argc, char *argv[]) {
    // Setup signal handlers
    struct sigaction new_action, old_action;
    new_action.sa_handler = handle_signal;
    new_action.sa_flags = 0;
    sigemptyset(&new_action.sa_mask); // Best practice
    sigaction(SIGINT, &new_action, &old_action);
    sigaction(SIGTERM, &new_action, &old_action);

    settings.quiet = false;
    settings.running = false;
    settings.tui_mode = false;
    settings.server.sin_family = AF_INET;
    settings.server.sin_port = htons(8080);
    inet_aton("127.0.0.1", &(settings.server.sin_addr));

    if (get_username() == -1) return -1;
    if (process_args(argc, argv) == -1) return -1;

    settings.socket_fd = socket(settings.server.sin_family, SOCK_STREAM, 0);
    if (settings.socket_fd == -1) return -1;

    if (connect(settings.socket_fd, (const struct sockaddr*)&(settings.server), sizeof(settings.server)) == -1) {
        fprintf(stderr, "Error: connection to server failed\n");
        return -1;
    }

    // Send login
    message_t login_message;
    login_message.type = LOGIN;
    strcpy(login_message.username, settings.username);
    login_message.type = htonl(login_message.type);
    write(settings.socket_fd, &login_message, sizeof(login_message));

    settings.running = true;

    // Start receive thread
    pthread_t thread1;
    pthread_create(&thread1, NULL, receive_messages_thread, NULL);

    if (settings.tui_mode) {
        enable_raw_mode();
        draw_interface();

        char c;
        while (settings.running) {
            // Read 1 byte. read returns 0 if no input (because of VTIME in raw mode)
            if (read(STDIN_FILENO, &c, 1) == 1) {
                if (c == '\033') { // Escape sequence start
                    char seq[3];
                    if (read(STDIN_FILENO, &seq[0], 1) == 0) continue;
                    if (read(STDIN_FILENO, &seq[1], 1) == 0) continue;
                    
                    if (seq[0] == '[') {
                        if (seq[1] == 'A') { // Arrow Up
                             if (scroll_offset < history_count) scroll_offset++;
                        } else if (seq[1] == 'B') { // Arrow Down
                             if (scroll_offset > 0) scroll_offset--;
                        }
                    }
                } else if (c == 127 || c == 8) { // Backspace
                    if (input_len > 0) {
                        input_buffer[--input_len] = '\0';
                    }
                } else if (c == '\n' || c == '\r') { // Enter
                    if (input_len > 0) {
                        // Send Message
                        message_t send_message;
                        send_message.type = MESSAGE_SEND;
                        send_message.type = htonl(send_message.type);
                        strcpy(send_message.message, input_buffer);
                        write(settings.socket_fd, &send_message, sizeof(send_message));
                        
                        // Clear input
                        memset(input_buffer, 0, MAX_INPUT_LEN);
                        input_len = 0;
                        scroll_offset = 0; // Snap to bottom on send
                    }
                } else if (c == 3) { // Ctrl+C
                    handle_signal(SIGINT);
		} else if (c == 4) { // NEW: Ctrl+D (EOF)
    			handle_signal(SIGINT);
                } else if (isprint(c)) {
                     if (input_len < MAX_INPUT_LEN - 1) {
                         input_buffer[input_len++] = c;
                         input_buffer[input_len] = '\0';
                     }
                }
                draw_interface();
            }
        }
    } else {
        // --- Original Standard Mode Loop ---
        while (settings.running == true) {
            char* message = NULL;
            size_t size = 0;
            ssize_t n_read = getline(&message, &size, stdin);
            if (n_read <= 0) break; // Simplified error handling
            
            // Basic validation
            if (n_read > 1023) { free(message); continue; }
            
            message_t send_message;
            send_message.type = MESSAGE_SEND;
            send_message.type = htonl(send_message.type);
            message[n_read-1] = '\0'; // Remove newline
            strcpy(send_message.message, message);
            
            if (write(settings.socket_fd, &send_message, sizeof(send_message)) <= 0) break;
            free(message);
        }
    }

    pthread_join(thread1, NULL);
    cleanup();
    return 0;
}
