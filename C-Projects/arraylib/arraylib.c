# include "arraylib.h"
# include <stdio.h>


/*
This is the implementation of the functions in arraylib.h. 
Please read the comments in arraylib.h before you start working on this file.
*/

unsigned int find_all_matches(int arr[], int size, int target, int results[]){
    // Initialize index for results array	
    int result_index = 0;
    int total = 0;
    // Loop through arr searching for target
    // If target is found, add one to total and add index to results array
    for (int i = 0; i < size; i++) {
	if (arr[i] == target) {
		total += 1;
		results[result_index] = i;
		result_index++;
	}	
    }
    return total;
}

unsigned int sum_positives(int arr[], int size){
    // Create unsigned int since that's what must be returned
    unsigned int sum = 0;
    // Check each value in arr
    // If it is positive, add it to sum
    for (int i = 0; i < size; i++) {
	    if (arr[i] >= 0) {
		    sum += arr[i];
	    }
    }
    return sum;
}

bool contains_prime(unsigned int arr[], int size){
    // Return false if size of given arr is zero
    if (size == 0) return false;
    // Loop through array
    for (int i = 0; i < size; i++) {
	    // If array value is 2, return true
	    if (arr[i] == 2) return true;
	    // If array value is greater than 1, loop through all values less than array value (j)
	    // If the array value divided by j has a remainder of zero, this means that j is a factor of the array value. Add 1 to factors. 
	    int factors = 0;
	    if (arr[i] > 1) {
	    for (int j = 2; j < arr[i]; j++) {
		if ((arr[i] % j) == 0) {
			factors += 1;
		}	
	    }
	    // If facotors is not zero, then it is not a prime number. Move on to check next array value
            // If factors still equals zero, this means the array value is prime. Thus, return true.
            if (factors == 0) return true;
	    }
    }
    //If we checked everything and never returned true, then each value must not be prime. Thus, return false
    return false;
}

bool is_reverse_sorted(int arr[], int size){
    // Create integer for current number to check
    int current_num = 0;
    // Loop through array, and check if the next number is greater than current number
    // Make sure to not go out of bounds of array by making last loop when i=size-2
    for (int i = 0; i < (size-1); i++) {
	    current_num = arr[i];
	    if (current_num < arr[i+1]) {
		    return false;
	    }
    }
    return true;
}

int find_max(int arr[], int size){
    // Return 0 if empty array
    if (size == 0) {
	    return 0;
    }
    // Create integer for max value
    int max = arr[0];
    // Loop through and compare each value of array to max. If a value is greater, then set max to that value
    for (int i = 1; i < size; i++) {
	if (arr[i] > max) {
		max = arr[i];
	}
    }
    return max;
}

int strlenm(char arr[], int max_length){
    // Loop through string in array until we find \0 or we go over max_length
    // If we go over max_length, return -1
    // If we find \0, return length of string found
    int i = 0;
    while (i <= max_length) {
	    if (arr[i] == '\0') {
		    return i;
	    }
	    i++;
    }
    return -1;
}

unsigned int strcnt(char arr[]){
    // Create variable to know if word has started
    bool character_start = false;
    int index = 0;
    int num_of_words = 0;
    // Loop through array until terminator is reached
    // if any of the four tokens are found, check if word has started
    // if already started, then end word
    // if anything other than the four tokens are found, check if word has started
    // if it hasn't, start word and add one to num_of_words
    // if it has, do nothing
    while (arr[index] != '\0') {
	if ((arr[index] == ' ') || (arr[index] == '\t') || (arr[index] == '\n') || (arr[index] == '-')) {
		if (character_start == true) {
			character_start = false;
			}	
	}
	else {
		if (character_start == false) {
                        character_start = true;
                        num_of_words += 1;
                	}
		}
	index++;
    }
    return num_of_words;
}

int strfind(char arr[], char target){
    // Loop through array until null terminator is found
    // Check each value of array with target value
    // If found, return index. If not found, return -1	
    int index = 0;
    while (arr[index] != '\0') {
	if (arr[index] == target) {
		return index;
	}
	index++;
    }
    // Check if target is the Null Character
    if (target == '\0') {
	    return index;
    }
    return -1;
}

