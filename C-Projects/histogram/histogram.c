#include "histogram.h"
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <errno.h>
#include <stdbool.h>
#include <math.h>
#include <fcntl.h>
#include <sys/stat.h>

// These function prototypes / definitions are suggestions but not required to implement.
// hist_int_t get_max_count(void)
// void output_histogram(FILE* destination_stream)
// void usr1_handler/exit_handler/signal_handler(int signum)

// Note: It is bad practice to use STDIO in signal handlers. 
// For this assignment however, I am guaranteeing that multiple signals will **not** be sent at or near the same time, thus it is __okay__ to use STDIO in your signal handlers.
// That is to say, feel free to use printf, fprintf, etc. in your signal handlers.
// Challenge: For the astute, try to implement the histogram program where your signal handlers have only 1 line of code (setting a global variable/flag). Even better if you use sigaction instead of signal.

// Micah's code

hist_int_t get_max_count(void) {
	// Goal: Find max count in histogram array
	hist_int_t max = 0;
	int i = 0;
	// Loop through array, check for max
	while (i < 256) {
		if (histogram[i] > max) {
			max = histogram[i];
		}
		i++;
	}
	return max;
}

void output_histogram(FILE* destination_stream) {
        // Goal: Output histogram	
	for (int i = 0; i < 256; i++) {
		// Make sure output is right aligned 20 chars and follows specifed format
		// Output if count is 0
		if (histogram[i] == 0) {
			fprintf(destination_stream, "%20llu 0x%02X |\n", histogram[i], i);
		// Output if count is not 0
		} else {
			// Find number of hashes that need to be printed
			// Create array of hashes so it can be easily printed
			hist_int_t max = get_max_count();
			int num_hash = floor(((double)histogram[i] / max) * MAX_BAR_WIDTH);
			char str[num_hash + 1];
			for (int j = 0; j < num_hash; j++) {
				str[j] = '#';
			}
			str[num_hash] = '\0';
			fprintf(destination_stream, "%20llu 0x%02X |%s|\n", histogram[i], i, str);
		}
	}
}

void signal_helper() {
	// Handle signals
        // Open histo.out file
        char path[] = "histo.out";
	// Open file correctly and with correct permissions
        int handle = open(path, O_RDWR | O_CREAT | O_TRUNC, S_IRWXU);
        // Check for error
	// If error, print to stderr and exit with negative exit code
        if (handle == -1) {
                perror("Error: Opened failed");
                _exit(-1);
        }
        // Convert handle to stream and check for error
        FILE* stream = fdopen(handle, "w+");
        if (stream == NULL) {
                perror("Error: handle conversion failed");
                _exit(-1);
        }
        // Output current histogram to file and then close file
        output_histogram(stream);
	fclose(stream);
}

void SIGUSR1_handler(int sig_num) {
	signal_helper();
}

void double_handler(int sig_num) {
	signal_helper();
	// Kill/exit process immediately
	raise(9);
}


int main(void) {
    // Catch signals manually
    signal(SIGUSR1, SIGUSR1_handler);
    signal(SIGINT, double_handler);
    signal(SIGTERM, double_handler);
    // Read from stdin 1 byte at a time
    unsigned char byte;
    int byte_read;
    bool progress = true;
    while (progress) {
    	byte_read = read(0, &byte, 1);
	// Check for error from signal or actual error
        if (byte_read == -1) {
        	if (errno == EINTR) continue;
                else {
			// If actual error, print to stderr and output negative return value
			fprintf(stderr, "Error: Error when reading");
			return -1;
		}
        }
	// Check if all bytes from stdin have been read
	if (byte_read == 0) break;
	// Add to count based on what byte is
        histogram[byte] += 1;
    }
    // Output histogram and return 0 to signify success
    output_histogram(stdout);
    return 0;
}
