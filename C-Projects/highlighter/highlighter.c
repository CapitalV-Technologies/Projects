#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <stdbool.h>

/*
This is the implementation of the highlighter program.
Please read the documentation in the README before you start working on this file.
*/

// Color codes to use in your program. Print a color first, then your text, then the reset color.
static const char* COLOR_RED = "\033[0;31m";
static const char* COLOR_GREEN = "\033[0;32m";
static const char* COLOR_BLUE = "\033[0;34m";
static const char* COLOR_YELLOW = "\033[1;33m";
static const char* COLOR_MAGENTA = "\033[0;35m";
static const char* COLOR_CYAN = "\033[0;36m";
static const char* COLOR_WHITE = "\033[1;37m";
static const char* COLOR_RESET_COLOR = "\033[0m";


// These function prototypes / definitions are suggestions but not required to implement.
// typedef struct Settings with fields FILE*/handle input_stream, output_stream; strings search_text, prefix, postfix; and boolean no_color;
// void print_help()
// void print_error(const char* error_message)
// void output_final_result(int count, const char* search_text)
// const char* get_color_code(const char* color_str)
// int process_args(int argc, char* argv[], Settings* settings)
// int parse_line(Settings* settings, char* line)
// ...

// Start of Micah's Code


// Create struct with needed fields
typedef struct Settings {
	char* input_stream;
	char* output_stream;
	const char* color;
	char* search_text;
	char* prefix;
	char* postfix;
	bool no_color;
} settings_t;

int parse_line(settings_t* settings, char* line, FILE* output) {
	// Goal: Check for matches within line and write line accordingly
	int length = strnlen(settings->search_text, 255);
	int total_matches = 0;
	char* match_position = line;
	char* current_position = line;
	while (match_position != NULL) {
		// Check for match in line
		match_position = strstr(match_position, settings->search_text);
		//If not found, will return NULL
		if (match_position != NULL) {
			// If match found, first print all characters up until first character in match
			int letters = match_position - current_position;
			fprintf(output, "%.*s", letters, current_position);
			current_position += letters;
			total_matches += 1;
			current_position += length;
			// Next, print match with prefix (if given), postfix (if given) and color (if given)
			if (settings->prefix != NULL) {
                                fprintf(output, "%s", settings->prefix);
                        }
                        if (settings->no_color) {
                                fprintf(output, "%s", settings->search_text);
                        } else {
                                fprintf(output, "%s%s%s", settings->color, settings->search_text, COLOR_RESET_COLOR);
                        }
                        if (settings->postfix != NULL) {
                                fprintf(output, "%s", settings->postfix);
                        }
                        match_position += length;
		// Lastly, print rest of line
		} else {
			fprintf(output, "%s", current_position);
		}
	}
	// Return total matches found
	return total_matches;
}



void print_help() {
	// Print help message
	printf("usage: ./highlighter [-h] [-i INPUT] [-o OUTPUT] [-c {RED,GREEN,BLUE,YELLOW,MAGENTA,CYAN,WHITE}] [--no-color] [--prefix PREFIX] [--postfix POSTFIX] text\n\nhighlighter\n\npositional arguments:\ntext                  text to match and highlight\n\noptions:\n  -h, --help            show this help message and exit\n  -i INPUT, --input INPUT\n                        input file (default: stdin)\n  -o OUTPUT, --output OUTPUT\n                        output file (default: stdout)\n  -c {RED,GREEN,BLUE,YELLOW,MAGENTA,CYAN,WHITE}, --color {RED,GREEN,BLUE,YELLOW,MAGENTA,CYAN,WHITE}\n                        color option (default: RED)\n  --no-color            do not print color\n  --prefix PREFIX       print prefix before highlighted text (default: empty string)\n  --postfix POSTFIX     print postfix after highlighted text (default: empty string)\n\nexamples:\n  ./highlighter -i file.txt \"error\" (highlights \"error\" in file.txt in red via STDOUT)\n  ./highlighter -c GREEN \"warning\" (highlights \"warning\" in green from STDIN to STDOUT)\n  ./highlighter --prefix \">>\" --postfix \"<<\" \"keyword\" -o out.txt (highlights \"keyword\" with prefix \">>\" and postfix \"<<\" in red from STDIN to out.txt)\n");
}

void print_error(const char* error_message) {
	// Print to stderr given error message
	fprintf(stderr, "Error: %s\n", error_message);
}

const char* check_valid_color(char* color) {
	// Check for valid color. If valid, return the correct color code 
	// If invalid, return COLOR_RESET_CODE to signal error
	if (strncmp(color, "RED", 4) == 0) return COLOR_RED;
	else if (strncmp(color, "GREEN", 6) == 0) return COLOR_GREEN;
	else if (strncmp(color, "BLUE", 5) == 0) return COLOR_BLUE;
	else if (strncmp(color, "YELLOW", 7) == 0) return COLOR_YELLOW;
	else if (strncmp(color, "MAGENTA", 8) == 0) return COLOR_MAGENTA;
	else if (strncmp(color, "CYAN", 5) == 0) return COLOR_CYAN;
	else if (strncmp(color, "WHITE", 6) == 0) return COLOR_WHITE;
	else return COLOR_RESET_COLOR;
}

int process_args(int argc, char* argv[], settings_t* settings) {
	// Check argc value
	if (argc < 2) {
		char error_message[] = "no arguments given";
                print_error(error_message);
		return -1;
	}
	// Loop through each given argument
        bool skip_i = false;
	bool text_already_given = false;
	for (int i = 1; i < argc; i++) {
		// Check if i was already parsed such as an argument to a -i or -o
		if (skip_i) {
			skip_i = false;
			continue;
		}
		// if -h, call print_help() and return -1 to exit
        	if ((strncmp(argv[i], "-h", 3) == 0) || (strncmp(argv[i], "--help", 7) == 0)) {
               		print_help();
               		return -1;
        	}
		// if -i, check if input file given. If not, error
		else if ((strncmp(argv[i], "-i", 3) == 0) || (strncmp(argv[i], "--input", 8) == 0)) {
			if (i + 1 < argc) {
				// Copy file given into struct array
				int length = strnlen(argv[i + 1], 255);
                                settings->input_stream = (char*)malloc((length + 1) * sizeof(char));
                                if (settings->input_stream == NULL) return -1;
                                strncpy(settings->input_stream, argv[i + 1], (length + 1));
				skip_i = true;
			} else {
				char error_message[] = "filename does not follow";
				print_error(error_message);
				return -1;
			}
		// if -o, check if output file given, If not, error
		} else if ((strncmp(argv[i], "-o", 3) == 0) || (strncmp(argv[i], "--output", 9) == 0)) {
			if (i + 1 < argc) {
                                // Copy file given into struct array
				int length = strnlen(argv[i + 1], 255);
                                settings->output_stream = (char*)malloc((length + 1) * sizeof(char));
                                if (settings->output_stream == NULL) return -1;
                                strncpy(settings->output_stream, argv[i + 1], (length + 1));
				skip_i = true;
                        } else {
                                char error_message[] = "filename does not follow";
				print_error(error_message);
				return -1;
			}
		// if -c, check if valid color given. If not, error
		} else if ((strncmp(argv[i], "-c", 3) == 0) || (strncmp(argv[i], "--color", 8) == 0)) {
			if (i + 1 < argc) {
				// Check for valid color
				const char* check_color = check_valid_color(argv[i+1]);
				if (check_color != COLOR_RESET_COLOR) {
					settings->color = check_color;
					skip_i = true;
				} else {
					char error_message[] = "invalid color given";
                                	print_error(error_message);
					return -1;
				}
                        } else {
                                char error_message[] = "no color given";
				print_error(error_message);
				return -1;
			}
		// Check for --no-color argument. If so, set no_color to true 
		} else if (strncmp(argv[i], "--no-color", 11) == 0) {
				settings->no_color = true;
		// Check for --prefix argument. If so, check for prefix given after. If not, error
		} else if (strncmp(argv[i], "--prefix", 9) == 0) {
			if (i + 1 < argc) {
				// Copy prefix given into struct array
				int length = strnlen(argv[i + 1], 255);
                                settings->prefix = (char*)malloc((length + 1) * sizeof(char));
				if (settings->prefix == NULL) return -1;
				strncpy(settings->prefix, argv[i + 1], (length + 1));
				skip_i = true;		
			} else {
                                char error_message[] = "no prefix given";
                                print_error(error_message);
				return -1;
                        }
		// Check for --postfix argument. If so, check for postfix given after. If not, error
		} else if (strncmp(argv[i], "--postfix", 10) == 0) {
                        if (i + 1 < argc) {
				// Copy postfix given into struct array
                                int length = strnlen(argv[i + 1], 255);
                                settings->postfix = (char*)malloc((length + 1) * sizeof(char));
				if (settings->postfix == NULL) return -1;
                                strncpy(settings->postfix, argv[i + 1], (length + 1));
				skip_i = true;
                        } else {
                                char error_message[] = "no postfix given";
                                print_error(error_message);
				return -1;
                        }
		// anything else must be the text argument
		} else {
			// Check if text argument has already been found
			if (text_already_given) { 
                		char error_message[] = "too many text arguments given";
                		print_error(error_message);
                		return -1;
			} else { 
				text_already_given = true;
				// Check for empty text argument
        			int length = strnlen(argv[i], 255);
				if (length == 0) {
					char error_message[] = "empty search text";
                                	print_error(error_message);
					return -1;
				}
				// Copy text argument given into struct array
        			settings->search_text = (char*)malloc((length + 1) * sizeof(char));
        			if (settings->search_text == NULL) return -1;
        			strncpy(settings->search_text, argv[i], (length + 1));
			}
		}
	}
	return 0;
}

void deallocate_struct(settings_t* settings) {
    // Free everything in struct array and NULL all pointers
    free(settings->search_text);
    free(settings->prefix);
    free(settings->postfix);
    free(settings->input_stream);
    free(settings->output_stream);
    settings->input_stream = NULL;
    settings->output_stream = NULL;
    settings->search_text = NULL;
    settings->prefix = NULL;
    settings->postfix = NULL;
    free(settings);
    settings = NULL;
}

int main(int argc, char *argv[]) {
    // Create initial Settings structure and set default values
    settings_t* settings = (settings_t*)malloc(sizeof(settings_t));
    if (settings == NULL) return -1;
    settings->input_stream = NULL;
    settings->output_stream = NULL;
    settings->color = COLOR_RED;
    settings->search_text = NULL;
    settings->prefix = NULL;
    settings->postfix = NULL;
    settings->no_color = false;
    // process arguments
    int success = process_args(argc, argv, settings);
    // Check for error 
    if (success == -1) {
	    deallocate_struct(settings);
	    return -1;
    }
    // Check for no arguments given
    if (settings->search_text == NULL) {
	char error_message[] = "no text given";
        print_error(error_message);
        deallocate_struct(settings);
        return -1;
    }
    FILE* input = NULL;
    FILE* output = NULL;
    //open input and output files.
    if (settings->input_stream == NULL) {
	input = stdin;
    } else {
	input = fopen(settings->input_stream, "r");
	if (input == NULL) {
        char error_message[] = "file not found";
        print_error(error_message);
	deallocate_struct(settings);
        return -1;
	}
    }
    if (settings->output_stream == NULL) {
        output = stdout;
    } else {
        output = fopen(settings->output_stream, "w");
	if (output == NULL) {
        char error_message[] = "opening file failed";
        print_error(error_message);
	deallocate_struct(settings);
        return -1;
	}
    }
    // Go through each line of file and call parse line.
    char* line = NULL;
    size_t len = 0;
    int total = 0;
    ssize_t num_read = getline(&line, &len, input);
    while (num_read != -1) {
	total += parse_line(settings, line, output);
	num_read = getline(&line, &len, input); 
    }
    // Print how many matches found
    fprintf(stderr, "Highlighted %d matches.\n", total);
    free(line);
    line = NULL;
    // Close files, null pointers, deallocate struct
    int suc = fclose(input);
    if (suc != 0) {
	char error_message[] = "file did not close properly";
        print_error(error_message);
    }
    int suc1 = fclose(output);
    if (suc1 != 0) {
        char error_message[] = "file did not close properly";
        print_error(error_message);
    }
    input = NULL;
    output = NULL;
    deallocate_struct(settings);
    // Return 0 to indicate success
    return 0;
}
