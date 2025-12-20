#include "genarraylib.h"
#include <stdio.h>
#include <string.h>

/*
This is the implementation of the functions in genarraylib.h. 
Please read the comments in genarraylib.h before you start working on this file.
*/

// You are allowed to define any helper functions or helper structs here.

// hint, a new struct for chunk index, element index may be helpful eventually.
// struct ...;
// typedef ...;


// hint, a new helper function for translating an index to the above struct may also be helpful.
// index -> struct;


generic_element_t create_generic_element(bool usable) {
    // Check usable value
    // If true, set type = void
    // If false, set type = error
    // Initilize value to zero
    generic_element_t element;
    if (usable == true) {
	element.type = GENERIC_TYPE_VOID;
    } else {
	element.type = GENERIC_TYPE_ERROR;
    }
    element.value.int_value = 0;
    return element;
}


generic_array_chunk_t create_generic_array_chunk(const int capacity) {
    // Initialize new chunk
    generic_array_chunk_t chunk;
    // Check capacity
    // If greater than max, set element_capacity as max
    // If less than 0, set as 0. Else set to given capacity
    if (capacity > MAX_ELEMENTS_PER_CHUNK) {
	    chunk.element_capacity = MAX_ELEMENTS_PER_CHUNK;
    } else if (capacity < 0) {
	chunk.element_capacity = 0;
    } else {
	chunk.element_capacity = capacity;
    }
    // Initialize each element for elements array
    // Initialize to VOID first 'capacity' number of elements
    // Initialzie to ERROR the rest of elements
    for (int i = 0; i < MAX_ELEMENTS_PER_CHUNK; i++) {
	if (i < chunk.element_capacity) {
		chunk.elements[i] = create_generic_element(true);
	} else {
		chunk.elements[i] = create_generic_element(false);
	}
    } 
    return chunk;
}


generic_array_t create_generic_array(const int chunk_capacity, const int per_chunk_capacities[], const int num_initial_elements) {
    // Initialize array
    generic_array_t array;
    // Check chunk_capacity
    // If over max, set array chunk_capacity to max
    // If less than 0, set array chunk_capacity to 0
    // Else, set to given chunk_capacity
    if (chunk_capacity > MAX_CHUNKS) {
            array.chunk_capacity = MAX_CHUNKS;
    } else if (chunk_capacity < 0) {
        array.chunk_capacity = 0;
    } else {
        array.chunk_capacity = chunk_capacity;
    }
    // Initialize chunks
    for (int i = 0; i < MAX_CHUNKS; i++) {
	// Check if chunk is within scope of chunk_capacity
	if ( i < array.chunk_capacity) {
		// Check if chunk can be initialized using per_chunk_capacities
		if (per_chunk_capacities != NULL) {
			array.chunks[i] = create_generic_array_chunk(per_chunk_capacities[i]);
		}
	// If not in scope of chunk_capacity, initialize chunk with 0 non_ERROR elements
    	} else {
		array.chunks[i] = create_generic_array_chunk(0);
	}
    }
    // Get total_element by summing all entries in per_chunk_capacities
    array.total_elements = 0;
    // Check if array is NULL
    if (per_chunk_capacities != NULL) {
    	for (int i = 0; i < array.chunk_capacity; i++) {
		// Check if per_chunk_capacities is over MAX_ELEMENTS_PER_CHUNK
		if (per_chunk_capacities[i] < MAX_ELEMENTS_PER_CHUNK) {
			array.total_elements += per_chunk_capacities[i];
		} else array.total_elements += MAX_ELEMENTS_PER_CHUNK;
    	}
    }
    // For num_initial_elements, initialize elements type to INT and set value to incrementing of 1 starting at 0
    if (num_initial_elements > 0) {
    	int already_initialized = 0;
	int integer_value = 0;
    	for (int i = 0; i < array.chunk_capacity; i++) {
		// Only initialize non-ERROR type elements 
		for (int j = 0; j < array.chunks[i].element_capacity; j++) {
			// Check to make sure number of initialized elements does not exceed total elements or given number of inital elements
			if ((already_initialized != num_initial_elements) && (already_initialized != array.total_elements)) {
				array.chunks[i].elements[j].type = GENERIC_TYPE_INT;
				array.chunks[i].elements[j].value.int_value = integer_value;
				integer_value += 1;
				already_initialized += 1;
                	}
		}		
    	}
    }
    
    return array;
}


generic_element_t get_element(generic_array_t genarr, const int index) {
    generic_element_t element;
    // Initialize element to an ERROR type element
    element = create_generic_element(false);
    if (index < 0) return element; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
	// If index is less than non-ERROR elements in chunk, set return element found at given index
	// If not, subract number of elements in chunk from index
	if (ind < genarr.chunks[i].element_capacity) {
		return genarr.chunks[i].elements[ind];
	} else {
		ind = ind - genarr.chunks[i].element_capacity;
	}
    }
    // If index is out of bounds, return ERROR type element
    return element;
}


generic_array_response_t set_element_int(generic_array_t genarr, const int index, const int value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index; 
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set integer value for given index, set type INT
	// Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.int_value = value;
		genarr.chunks[i].elements[ind].type = GENERIC_TYPE_INT;
		response.success = true;
		response.array = genarr;
		return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}

generic_array_response_t set_element_float(generic_array_t genarr, const int index, const float value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set float value for given index, set type FLOAT
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.float_value = value;
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_FLOAT;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


generic_array_response_t set_element_double(generic_array_t genarr, const int index, const double value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set double value for given index, set type DOUBLE
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.double_value = value;
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_DOUBLE;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


generic_array_response_t set_element_char(generic_array_t genarr, const int index, const char value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set char value for given index, set type CHAR
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.char_value = value;
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_CHAR;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


generic_array_response_t set_element_short(generic_array_t genarr, const int index, const short value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set short value for given index, set type SHORT
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.short_value = value;
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_SHORT;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


generic_array_response_t set_element_bool(generic_array_t genarr, const int index, const bool value) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set bool value for given index, set type BOOL
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
                genarr.chunks[i].elements[ind].value.bool_value = value;
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_BOOL;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


generic_array_response_t set_element_string(generic_array_t genarr, const int index, const char value[]) {
    generic_array_response_t response;
    // Initialize response array to false
    response.success = false;
    response.array = genarr;
    if (index < 0) return response; // check for negative index
    int ind = index;
    // Go through each chunk
    for (int i = 0; i < genarr.chunk_capacity; i++) {
        // If index is less than non-ERROR elements in chunk, set string value for given index, set type STRING
        // Set response.success to true and response.array to changed genarr, return response
        // If not, subract number of elements in chunk from index
        if (ind < genarr.chunks[i].element_capacity) {
		// Copy string
		// Find string length 
		int len = strnlen(value, MAX_CHAR_ARRAY_LENGTH);
		int string_index = 0;
		// Copy full string or until MAX_CHAR_ARRAY_LENGTH -1 since we need a spot for the NULL terminator
		while ((string_index < len) && (string_index < (MAX_CHAR_ARRAY_LENGTH-1))) {
                	genarr.chunks[i].elements[ind].value.string_value[string_index] = value[string_index];
			string_index++;
		}
		// Add NULL terminator
		genarr.chunks[i].elements[ind].value.string_value[string_index] = '\0';
                genarr.chunks[i].elements[ind].type = GENERIC_TYPE_STRING;
                response.success = true;
                response.array = genarr;
                return response;
        } else {
                ind = ind - genarr.chunks[i].element_capacity;
        }
    }
    // If index is out of bounds, return unsuccessful response
    return response;
}


bool is_equal_element(generic_element_t elem1, generic_element_t elem2) {
    // Compare if elements are the same
    // Check if types are the same
    if (elem1.type != elem2.type) {
	    return false;
    // Check if each value is the same based on type
    } else {
	switch(elem1.type) {
		case(GENERIC_TYPE_INT): 
			if (elem1.value.int_value == elem2.value.int_value) return true;
		case(GENERIC_TYPE_FLOAT):
                        if (elem1.value.float_value == elem2.value.float_value) return true;
		case(GENERIC_TYPE_DOUBLE):
                        if (elem1.value.double_value == elem2.value.double_value) return true;
		case(GENERIC_TYPE_CHAR):
                        if (elem1.value.char_value == elem2.value.char_value) return true;
		case(GENERIC_TYPE_SHORT):
                        if (elem1.value.short_value == elem2.value.short_value) return true;
		case(GENERIC_TYPE_BOOL):
                        if (elem1.value.bool_value == elem2.value.bool_value) return true;
		case(GENERIC_TYPE_STRING):
                        if (elem1.value.string_value == elem2.value.string_value) return true;
		case(GENERIC_TYPE_VOID):
                        if (elem1.value.int_value == elem2.value.int_value) return true;
		case(GENERIC_TYPE_ERROR):
                        if (elem1.value.int_value == elem2.value.int_value) return true;
	}
    }
    // If values aren't the same, return false
    return false;
}


bool is_equal(generic_array_t genarr1, generic_array_t genarr2) {
    // Check if total elements are the same in each array
    if (genarr1.total_elements != genarr2.total_elements) return false;
    int elements = genarr1.total_elements;
    int index = 0;
    // Stop once index hits total elements
    while (index != elements) {
	// Get elements to compare
	generic_element_t element1 = get_element(genarr1, index);
	generic_element_t element2 = get_element(genarr2, index);
	// If elements aren't equal or one is an ERROR element, return false
	if (!is_equal_element(element1, element2)) {
		return false;
	} else if ((element1.type == GENERIC_TYPE_ERROR) || (element2.type == GENERIC_TYPE_ERROR)) {
		return false;
	}
	index++;
    }
    // If nothing has returned yet, then arrays are equal.
    return true;
}
