# include "mylib.h"
# include <stdio.h>


/*
This is the implementation of the functions in mylib.h. 
Please read the comments in mylib.h before you start working on this file.
*/
float int_to_float(int input){
    float flt = (float)input; //Type cast given integer to float
    return flt;
}

int factorial(int input){
    if (input < 0) { // Can't do a factorial for a negative number
	    return -1; 
    }
    else if (input == 0) { // Factorial of 0 is 1
	    return 1;
    }
    return input * factorial(input - 1); // Use recursion to find factorial
}

int sum(int input){
    if (input == 0) { /* Base Case: for either direction, once we hit zero we stop */
	return 0;
    }
    if (input < 0) { /* When numbers are negative, keep adding one to get to zero */
	    return input + sum(input + 1);
    }
    else { /* When numbers are positive, keep subtracting one to get to zero */
	    return input + sum(input - 1);
    }
}

char grade_scale(float score){
    char letter = 'X'; 
    if (score < 0) return letter; //Not valid score, return X
    else if (score < 60) letter = 'F'; /* Check score and see which letter it corresponds to */
    else if (score < 70) letter = 'D';
    else if (score < 80) letter = 'C';
    else if (score < 90) letter = 'B';
    else if (score <= 100) letter = 'A';
    else return letter; //Not valid score, return X
    return letter;
}

bool is_even(int input){
    if ((input % 2 ) == 0) return true;//All even integers mod 2 will be 0//
    return false;
}

int num_factors(int input){
    if (input <= 0) return -1; //Not dealing with negative numbers or 0 for this problem
    int count = 0;
    //Check if input divided by i (each integer from 1 to input) gives a whole number (no remainder)
    //Count how many times this happens, return count
    for (int i = 1; i <= input; i++) {
	    if ( (input % i) == 0) {
		    count++;
	    }
    }
    return count;
}

int max_of_three(int a, int b, int c){
	// Find largest integer by comparing it to the others. Then return it
    if ((a >= b) && ( a >= c)) return a;
    else if ((b >= a) && (b >= c)) return b;
    return c;
}

int days_in_month(int month){
// Based on input month, return number of days
// If not a valid month, return -1
    	switch (month) {
		//Months with 31 days
	    case 1:
	    case 3:
	    case 5:
	    case 7:
	    case 8:
	    case 10:
	    case 12:
		    return 31;
		    //Months with 28 days
	    case 2:
		    return 28;
		    //Months with 30 days
	    case 4:
	    case 6:
	    case 9:
	    case 11:
		    return 30;
	    default:
	            return -1;
    }
}

float divide(int a, int b){
    if (b == 0) return (float)-1; //Can't divide by Zero, must return a float
    float quotient = ((float)a / (float)b); // Conduct Real Division
    return quotient;
}

char to_uppercase(char input){
// use ASCII Table
    if (input >= 97 && input <= 122) return (input - 32); //Check if lowercase, if it is, subtract 32 to get Uppercase. 
    return '0'; // If it's not a lowercase letter, return Zero
}
