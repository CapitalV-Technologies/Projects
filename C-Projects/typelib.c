#include "typelib.h"
#include <stdio.h>
#include <string.h>

/*
This is the implementation of the functions in typelib.h. 
Please read the comments in typelib.h before you start working on this file.
*/

letter_grade_t percentage_to_letter(float percentage) {
    // Check percentage value
    // Return corresponding letter grade enum value based on Grading Scale
    // Return GRADE_INVALID if not in grading scale	
    if (percentage < 0) return GRADE_INVALID;
    else if (percentage < 60) return GRADE_F;
    else if (percentage < 63) return GRADE_D_MINUS;
    else if (percentage < 67) return GRADE_D;
    else if (percentage < 70) return GRADE_D_PLUS;
    else if (percentage < 73) return GRADE_C_MINUS;
    else if (percentage < 77) return GRADE_C;
    else if (percentage < 80) return GRADE_C_PLUS;
    else if (percentage < 83) return GRADE_B_MINUS;
    else if (percentage < 87) return GRADE_B;
    else if (percentage < 90) return GRADE_B_PLUS;
    else if (percentage < 93) return GRADE_A_MINUS;
    else if (percentage < 97) return GRADE_A;
    else if (percentage <= 100) return GRADE_A_PLUS;
    else return GRADE_INVALID;
}

float letter_to_percentage(letter_grade_t letter) {
    // Check letter value
    // Based on letter value, return middle percentage value for that letter grade range in a float
    switch(letter) {
	case GRADE_A_PLUS:
		return 98.5;
	case GRADE_A:
		return 95.0;
	case GRADE_A_MINUS:
                return 91.5;
	case GRADE_B_PLUS:
                return 88.5;
	case GRADE_B:
                return 85.0;
	case GRADE_B_MINUS:
                return 81.5;
	case GRADE_C_PLUS:
                return 78.5;
	case GRADE_C:
                return 75.0;
	case GRADE_C_MINUS:
                return 71.5;
	case GRADE_D_PLUS:
                return 68.5;
	case GRADE_D:
                return 65.0;
	case GRADE_D_MINUS:
                return 61.5;
	case GRADE_F:
                return 30.0;
	case GRADE_INVALID:
                return -1.0;
    }
}

float letter_to_gpa(letter_grade_t letter) {
    // Check letter value
    // Based on letter value, return GPA value on 4.0 scale
    switch(letter) {
        case GRADE_A_PLUS:
                return 4.0;
        case GRADE_A:
                return 4.0;
        case GRADE_A_MINUS:
                return 3.7;
        case GRADE_B_PLUS:
                return 3.3;
        case GRADE_B:
                return 3.0;
        case GRADE_B_MINUS:
                return 2.7;
        case GRADE_C_PLUS:
                return 2.3;
        case GRADE_C:
                return 2.0;
        case GRADE_C_MINUS:
                return 1.7;
        case GRADE_D_PLUS:
                return 1.3;
        case GRADE_D:
                return 1.0;
        case GRADE_D_MINUS:
                return 0.7;
        case GRADE_F:
                return 0.0;
        case GRADE_INVALID:
                return -1.0;
    }
}

student_t create_student(int student_id, const char first_name[], const char last_name[], int year_level, bool is_suspended) {
    // Initialize new student
    student_t student = {0};
    // using strncpy, copy first and last name into student structure
    strncpy(student.first_name, first_name, MAX_FIRST_NAME_LENGTH);
    strncpy(student.last_name, last_name, MAX_LAST_NAME_LENGTH);
    // Set given variables to corresponding variables in student structure
    student.student_id = student_id;
    student.year_level = year_level;
    student.is_suspended = is_suspended;
    return student;
}

course_t create_course(const char course_code[], const char course_name[], int credits, int max_students) {
    // Initialize new course
    // Set current_enrollment to 0 and empty array of students
    course_t course = {0};
    // using strncpy, copy course_code and course_name into course structure
    strncpy(course.course_code, course_code, MAX_COURSE_CODE_LENGTH);
    strncpy(course.course_name, course_name, MAX_COURSE_NAME_LENGTH);
    // Set given variables to corresponding variables in course structure
    course.credits = credits;
    course.max_students = max_students;
    return course;
}

bool is_course_at_capacity(course_t course) {
    // Check if current enrollment is less than max possible enrollment (max_students)
    if (course.current_enrollment < course.max_students) {
	return false;
    }
    return true;
}

course_t add_student_to_course(course_t course, student_t student) {
    // Check if course is at capacity. If it is, do nothing.
    // If it's not, add student to course if not already in course
    if (!is_course_at_capacity(course)) {
    //Check if student already exists in array
    int index = 0;
    bool exists = false;
    //Loop until max students allowed checked or student_id is 0
    while ((course.students[index].student_id != 0) && (index != MAX_STUDENTS)) {
	// if student_ids match, set exists to true
	if (course.students[index].student_id == student.student_id) {
		exists = true;
	}
	index += 1;
    }
    // if student not in array, add it
    // if already in array, do nothing
    if (exists == false) {
    course.students[course.current_enrollment] = student;
    course.current_enrollment += 1;
    }
    }
    return course;
}

float calculate_student_average(grade_t grades[], int num_grades, int student_id) {
    // Create float variables for grade totals and number of assignments
    float grade_total = 0.0;
    float number_of_assignments = 0.0;
    int index = 0;
    // Loop through grades array
    while (index != num_grades) {
	// Check if grade_t struct student_id matches given student_id
	if (grades[index].student_id == student_id) {
		// If it does, check if grade is a percentage
		// If it is, add to grade_total and number of assignments
		if (grades[index].is_percentage) {
			grade_total += grades[index].grade.percentage;
			number_of_assignments += 1.0;
		// If not a percentage, convert to a percentage and then add to grade_totoal and number of assignments
		} else {
			grade_total += letter_to_percentage(grades[index].grade.letter);
			number_of_assignments += 1.0;
		}
	}
	    index++;
    }
    // Check to make sure we had at least one assignment for the given student_id
    if (number_of_assignments != 0.0) {
	// return average
	return (grade_total/number_of_assignments);
    }
    // return -1 if no assignments for given student_id
    return -1.0;
}

int find_top_student(grade_t grades[], int num_grades, student_t students[], int num_students) {
    // TODO: Find student with highest average grade
    // Create variables to keep track of highest average grade and which student_id has that highest average grade
    int index = 0;
    float max_average_grade = 0.0;
    int max_student_id = -1;
    // Loop through given student array
    while (index != num_students) {
	// Check if student is suspended. If suspended, stop since we only want non-suspended students highest average grade
	// If not suspedned, continue
	if (!students[index].is_suspended) {
		// Find average grade of student
		int average_grade = calculate_student_average(grades, num_grades, students[index].student_id);
		// Compare to max_average grade. If higher, set a new max and a new student_id
		if (average_grade > max_average_grade) {
			max_average_grade = average_grade;
			max_student_id =  students[index].student_id;
		}
	}
	index++;
    }
    // Return student_id with highest average grade. Will be -1 if there was zero non-suspended students or zero students in array students
    return max_student_id;
}

float calculate_class_average(grade_t grades[], int num_grades, student_t students[], int num_students) {
    // Create variables to store total non-suspended students and total average grades of those students.
    float total_average_grade = 0.0;
    float total_students = 0.0;
    int index = 0;
    // Loop through given students array
    while (index != num_students) {
	// Check if student is suspended
	if (!students[index].is_suspended) {
		// If student is not suspended, calculate student average grade and add it to total average grade
		// Add 1 to total number of students
		float average_grade = calculate_student_average(grades, num_grades, students[index].student_id);
		// Check to make sure we get a valid average grade
		if (average_grade != -1.0) {
		total_students += 1.0;
		total_average_grade += average_grade;
		}	
	}
	index++;
    }
    // Check if at least one valid grade found
    if ((num_grades != 0) && (total_students != 0.0)) {
	    // Return class average
	    return (total_average_grade/total_students);
    }
    // If no valid grades found, return 1.0
    return -1.0;
}

int count_students_by_year(student_t students[], int num_students, int year_level) {
    // Create variable to store total number of non-suspended students within given year_level
    int number_of_students = 0;
    int index = 0;
    // Loop through given students array
    while (index != num_students) {
	// If student is not suspended and is given year_level, add 1 to number_of_students
	if ((!students[index].is_suspended) && (students[index].year_level == year_level)) {
		number_of_students += 1;
	}
	index++;
    }
    // Return number of students found with given year level
    return number_of_students;
}

int calculate_total_credit_hours(course_t course) {
    // Create variable to store total enrolled non-suspended students
    int total_enrolled_students = 0;
    int index = 0;
    // Loop through students array in course structure
    while (index != course.current_enrollment) {
	// Check if student is suspended. If not, add them to total enrolled students
 	if (!course.students[index].is_suspended) {
		total_enrolled_students += 1;
	}
	index++;	
    }
    // return total credit hours by calculating it with credits*total students enrolled
    return (course.credits * total_enrolled_students);
}

int find_most_popular_course(course_t courses[], int num_courses) {
    // Create variables to store max_enrollment and it's index.
    int index = 0;
    int max_enrollment = 0;
    int saved_index = -1;
    // Loop through courses array
    while (index != num_courses) {
	// For each course, check if it's enrollment is greater than max enrollment
	// If it is, save the index and set new max enrollment
	if (courses[index].current_enrollment > max_enrollment) {
		saved_index = index;
		max_enrollment = courses[index].current_enrollment;
	}
	index++;
    }
    // Return index of highest enrollment course
    return saved_index;
}

int find_student_in_course(course_t course, int student_id) {
    int index = 0;
    // Loop through students array in course.
    while (index != course.current_enrollment) {
	// Check if student_id matches given student_id
	// If it does, return the index
	if (course.students[index].student_id == student_id) {
		return index;
	}
	index++;
    }
    // If we don't find a match for given student_id, return -1
    return -1;
}
