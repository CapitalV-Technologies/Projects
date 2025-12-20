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

// typedef enum MessageType { ... } message_type_t;
// Create Enums for Message Types
typedef enum MessageType {
    LOGIN = 0,
    LOGOUT = 1,
    MESSAGE_SEND = 2,
    MESSAGE_RECV = 10,
    DISCONNECT = 12,
    SYSTEM = 13

} message_type_t;

// typedef struct __attribute__((packed)) Message { ... } message_t;
// Create Struct for message
typedef struct __attribute__((packed)) Message {
    unsigned int type;
    unsigned int time;
    char username[32];
    char message[1024];
} message_t;

typedef struct Settings {
    struct sockaddr_in server;
    bool quiet;
    int socket_fd;
    bool running;
    char username[32];
} settings_t;

static char* COLOR_RED = "\033[31m";
static char* COLOR_GRAY = "\033[90m";
static char* COLOR_RESET = "\033[0m";
static settings_t settings = {0};

int process_args(int argc, char *argv[]) {
    // Create string arrays for argument parsing
    int index = 0;
    char help[] = "--help";
    char port[] = "--port";
    char ip[] = "--ip";
    char domain[] = "--domain";
    char quiet[] = "--quiet";
    bool ip_domain_given = false;
    // Parse arguments
    while (index < argc) {
	// Handle help flag
	if (strcmp(argv[index], help) == 0) {
		fprintf(stdout, "usage: ./client [-h] [--port PORT] [--ip IP] [--domain DOMAIN] [--quiet]\n\nmycord client\n\noptions:\n  --help                show this help message and exit\n  --port PORT           port to connect to (default: 8080)\n  --ip IP               IP to connect to (default: 127.0.0.1)\n  --domain DOMAIN       Domain name to connect to (if domain is specified, IP must not be)\n  --quiet               do not perform alerts or mention highlighting\n\nexamples:\n  ./client --help (prints the above message)\n  ./client --port 1738 (connects to a mycord server at 127.0.0.1:1738)\n  ./client --domain example.com (connects to a mycord server at example.com:8080)\n");
		return -1;
	// Handle port flag
	} else if (strcmp(argv[index], port) == 0) {
                // Check to make sure a following argument is given
		if (index + 1 < argc) {
			// Check for invalid port so explicit cast to unsigned short works correctly
			int port = atoi(argv[index + 1]);
			if ((port > 65535) || (port < 0)) {
				fprintf(stderr, "Error: Not a valid port number\n");
				return -1;
			}
			// Set new port value and skip next argument
			settings.server.sin_port = htons((unsigned short)port);
			index++;

		} else {
			fprintf(stderr, "Error: No port given\n");
			return -1;
		}
	// Handle ip flag
        } else if (strcmp(argv[index], ip) == 0) {
                // Check to make sure domain address hasn't been given already
		if (ip_domain_given == true) {
                        fprintf(stderr, "Error: IP address and Domain specified. Only one is allowed\n");
                        return -1;
                }
		// Check to make sure a following argument is given
                if (index + 1 < argc) {
			// Set new IP address in settings struct
                        int convert = inet_aton(argv[index + 1], &(settings.server.sin_addr));
			if ((convert == 0) || (convert == -1)) {
				fprintf(stderr, "Error: IP address conversion failed\n");
                        	return -1;
			}
                        index++;
			ip_domain_given = true;

                } else {
                        fprintf(stderr, "Error: No IP address given given\n");
                        return -1;
                }
	// Handle domain flag
	} else if (strcmp(argv[index], domain) == 0) {
                // Check to make sure a following argument is given
		// Check to make sure IP address is not given
		if (ip_domain_given == true) {
			fprintf(stderr, "Error: IP address and Domain specified. Only one is allowed\n");
                        return -1;
		}
                if (index + 1 < argc) {
			// Get IP address with domain name
			struct hostent* host_info = gethostbyname(argv[index + 1]);
			// Check if we found a valid IP4 address
			if ((host_info == NULL) || (host_info->h_addrtype != AF_INET) || (host_info->h_addr_list[0] == NULL)) {
				fprintf(stderr, "Error: Non-valid Domain name\n");
                        	return -1;
			}
                        settings.server.sin_addr = *(struct in_addr*)(host_info->h_addr_list[0]);
                        index++;
			ip_domain_given = true;

                } else {
                        fprintf(stderr, "Error: No IP address given given\n");
                        return -1;
                }
	// handle quiet flag
	} else if (strcmp(argv[index], quiet) == 0) {
                	settings.quiet = true;
                }
	index++;
    }
    // Return 0 to signify success
    return 0;
}

int get_username() {
    // Goal: get username using whoami shell command
    // Open another process
    FILE* username = popen("whoami", "r");
    if (username == NULL) {
	fprintf(stderr, "Error: Failed to get username\n");
	return -1;
    }
    // Read output of process
    char buffer[32];
    int index = 0;
    int c;
    while ((c = fgetc(username)) != EOF) {
	// Check to make sure character is printable ASCII
	// If not, don't add to username (removes newline character)
	if (isprint(c) != 0) {
		buffer[index] = c;
		index++;
		// Make sure username is not too long
		if (index == 31) {
			break;
		}
	}
    }
    pclose(username);
    // Check if username is empty
    if (index == 0) {
	fprintf(stderr, "Error: Empty username\n");
        return -1;
    }
    // Add a null terminator
    buffer[index] = '\0';
    // Add username to settings struct
    strcpy(settings.username, buffer);
    // Return 0 to signify success
    return 0;
}

ssize_t perform_full_read(void *buf, size_t n) {
    // Used previous test to help build this function
    // Check for valid inputs
    if ((buf == NULL) || (n < 1)) return -1;
    int total = 0;
    // Loop through to prevent short read
    while (total < n) {
	// Read from network socket the correct number of bytes
	int curr = read(settings.socket_fd, buf + total, n - total);
	if (curr == 0) return 0;
	// Check for error or signal interrupt
	// Continue if signal interrupt
	// return -1 for error
	if (curr == -1) {
		if (errno == EINTR) continue;
		fprintf(stderr, "Error: read errored\n");
		raise(SIGINT);
		return -1;
	}
	total += curr;
    }
    return total;
}

void* receive_messages_thread(void* arg) {
    // while some condition(s) are true
    //Use settings.running as global flag
    while (settings.running == true) {
        // read message from the server (ensure no short reads)
	message_t recieved_message;
	ssize_t n = perform_full_read(&recieved_message, sizeof(recieved_message));
	// if n = 0, then server closed the connection. Don't send Logout, immediately kill
	if (n == 0) {
		settings.running = false;
		break;	
	}
	// Convert everything to host bytes. Don't need to convert arrays
	recieved_message.type = ntohl(recieved_message.type);
	recieved_message.time = ntohl(recieved_message.time);	
        // check the message type
        if (recieved_message.type == SYSTEM) {
            // for system types, print the message in gray with username SYSTEM
	    char system[] = "[SYSTEM]";
	    fprintf(stdout, "%s%s %s%s\n", COLOR_GRAY, system, recieved_message.message, COLOR_RESET);
	} else if (recieved_message.type == DISCONNECT) {
            // for disconnect types, print the reason in red with username DISCONNECT and exit
	    char disconnect[] = "[DISCONNECT]";
            fprintf(stdout, "%s%s %s%s\n", COLOR_RED, disconnect, recieved_message.message, COLOR_RESET);
	    settings.running = false;
	    // I realize this causes a memory leak, but couldn't figure out how to solve this (and not have stdin lag) in time. 
	    raise(SIGKILL);
	} else if (recieved_message.type == MESSAGE_RECV) {
            // for message types, print the message and do highlight parsing (if not quiet)
            // Handle Time
            time_t time = (time_t)recieved_message.time;
            struct tm* tm = localtime(&time);
            char buffer[256];
            strftime(buffer, 256, "%Y-%m-%d %H:%M:%S", tm);
            // Don't highlight if settings.quiet is true
            if (settings.quiet == true) {
                fprintf(stdout, "%s %s: %s\n", buffer, recieved_message.username, recieved_message.message);
            } else {
                // Highlight mentions
                // go character by character looking for the @ and our current username
                fprintf(stdout, "%s %s: ", buffer, recieved_message.username);
                int ind = 0;
                size_t len = strlen(settings.username);
                while ((ind < 1024) && (recieved_message.message[ind] != '\0')) {
                        if ((recieved_message.message[ind] == '@') && (strncmp(settings.username, &recieved_message.message[ind + 1], len) == 0)) {
                                fprintf(stdout, "\a%s@%s%s", COLOR_RED, settings.username, COLOR_RESET);
                                ind += len + 1;
                        } else {
                                putchar(recieved_message.message[ind]);
                                ind++;
                        }
                }
                putchar('\n');
            }
	} else {
            // for anything else, print an error
	    fprintf(stderr, "Error: Uknown Message Type\n");
	}
    }
}

void cleanup() {
	// Create function to clean up socket to reuse code
	close(settings.socket_fd);
    	settings.socket_fd = -1;
}

void handle_signal(int signal) {
    // Create logout message
    message_t logout_message;
    logout_message.type = LOGOUT;
    // Convert to Network byte order
    logout_message.type = htonl(logout_message.type);
    // Send message
    if (write(settings.socket_fd, &logout_message, sizeof(logout_message)) == -1) {
        fprintf(stderr, "Error: Login message failed to send\n");
    }
    // Clean up and stop running
    cleanup();
    settings.running = false;
    return;
}

int main(int argc, char *argv[]) {
    // setup sigactions (ill-advised to use signal for this project, use sigaction with default (0) flags instead)
    struct sigaction new_action, old_action;
    new_action.sa_handler = handle_signal;
    new_action.sa_flags = 0;
    sigaction(SIGINT, &new_action, &old_action);
    sigaction(SIGTERM, &new_action, &old_action);
    // Set inital values of settings struct
    settings.quiet = false;
    settings.running = false;
    settings.server.sin_family = AF_INET;
    uint16_t def = 8080;
    // Convert to Network byte order
    settings.server.sin_port = htons(def);
    int success = inet_aton("127.0.0.1", &(settings.server.sin_addr));
    if ((success) == 0 || (success == -1)) {
	fprintf(stderr, "Error: inet_aton failure\n");
	return -1;
    }
    // Get username and check for success
    success = get_username();
    if (success == -1) return -1;
    // parse arguments
    success = process_args(argc, argv);
    if (success == -1) return -1;
    // create socket
    settings.socket_fd = socket(settings.server.sin_family, SOCK_STREAM, 0);
    if (settings.socket_fd == -1) {
	fprintf(stderr, "Error: socket failed on creation\n");
	return -1;
    }
    // connect to server
    if (connect(settings.socket_fd, (const struct sockaddr*)&(settings.server), sizeof(settings.server)) == -1) {
	fprintf(stderr, "Error: connection to server failed\n");
	cleanup();
        return -1;
    }
    // create and send login message
    message_t login_message;
    login_message.type = LOGIN;
    strcpy(login_message.username, settings.username);
    // Convert to Network byte order
    login_message.type = htonl(login_message.type);
    if (write(settings.socket_fd, &login_message, sizeof(login_message)) == -1) {
	fprintf(stderr, "Error: Login message failed to send\n");
	cleanup();
	return -1;
    }
    settings.running = true;
    // create and start receive messages thread
    pthread_t thread1;
    pthread_create(&thread1, NULL, receive_messages_thread, NULL);
    // while some condition(s) are true
    while (settings.running == true) {
	bool skip_message_send = false;
        // read a line from STDIN
	char* message = NULL;
	size_t size = 0;
	ssize_t n_read = getline(&message, &size, stdin);
        // do some error checking (handle EOF, EINTR, etc.)
	if (n_read == -1) {
		// If interrupt, continue read
		if (errno == EINTR) {
			free(message);
			message = NULL;
			continue;
		}
		// If control D, gracefully exit by calling SIGINT
		if (feof(stdin) != 0) {
			raise(SIGINT);
			free(message);
			message = NULL;
			break;
		// If Read error, do same thing
		} else {
			fprintf(stderr, "Error: Read Error\n");
			raise(SIGINT);
                	free(message);
                	message = NULL;
			skip_message_send = true;
		}
	}
	// Check to make sure all characters are valid
	if ((n_read > 0) && (message[n_read - 1] == '\n')) { 
		size_t ind = 0; 
		while (ind < (n_read - 1)) {
			if (isprint(message[ind]) == 0) {
				// Don't send message if error in input (set bool skip_message_send to true)
				fprintf(stderr, "Error: Invalid input for message type\n");
				free(message);
				message = NULL;
				skip_message_send = true;
				break;
			}
		ind++;
		}	
	}
	// Check if message is too large
	if (n_read > 1023) {
		fprintf(stderr, "Error: Invalid input for message type; input too larger\n");
		free(message);
		message = NULL;
		skip_message_send = true;
	}
        // send message to the server
	// Check if we should send message or not
	if (skip_message_send == true) continue;
	message_t send_message;
	send_message.type = MESSAGE_SEND;
	// Convert to Network byte order
	send_message.type = htonl(send_message.type);
	if (message != NULL) {
		message[n_read - 1] = '\0';
		strcpy(send_message.message, message);
	}
	// Write to socket
	if (write(settings.socket_fd, &send_message, sizeof(send_message)) <= 0) {
		fprintf(stderr, "Error: encountered a write error\n");
		free(message);
		message = NULL;
		cleanup();
		raise(SIGINT);
		}
	// Clean up
	free(message);
	message = NULL;
	}
    // wait for the thread / clean up
    void* ret;
    pthread_join(thread1, &ret);
    // cleanup and return
    cleanup();
    return 0;
}
