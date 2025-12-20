#include "vectorlib.h"

/*
This is the implementation of the functions in vectorlib.h. 
Please read the comments in vectorlib.h before you start working on this file.
*/


// Feel free to define any helper functions, structs, or typedefs here.


vector_t* vector_create(unsigned int initial_capacity) {
    // Check for capacity of less than 0; if found, return NULL to signify error
    if (initial_capacity < 0) {
	    return NULL;
    }
    // Create vector with malloc
    vector_t* vector = (vector_t*)malloc(sizeof(vector_t));
    // Check for failed creation of vector
    if (vector == NULL) {
	    return NULL;
    }
    // Set initial values
    vector->num_chunks = 0;
    vector->num_elements = 0;
    vector->head = NULL;
    vector->tail = NULL;
    // Check for initial_capcity of 0
    if (initial_capacity == 0) {
	    return vector;
    // If not, call vector_extend to create first chunk
    } else {
	    vector_extend(vector, initial_capacity, true);
	    return vector;    
    }
}


int vector_destroy(vector_t* vector) {
    // Check for NULL vector
    if (vector == NULL) return -1;
    // First, loop through chunks freeing the array first and then the chunk.
    // Always set pointer to NULL after freeing
    vector_chunk_t* current_chunk = NULL;
    while (vector->head != NULL) {
	current_chunk = vector->head;
	vector->head = vector->head->next;
	// Set pointer to NULL
	current_chunk->next = NULL;
	free(current_chunk->elements);
	current_chunk->elements = NULL;
	free(current_chunk);	
    }
    // Set pointer to NULL
    current_chunk = NULL;
    vector->tail = NULL;
    // Lastly, free vector structure
    free(vector);
    vector = NULL;
    return 0;
}


int vector_extend(vector_t* vector, unsigned int num_elements, bool zero_fill) {
    // Check if num_elements is 0 or vector is NULL
    if (vector == NULL) return -1;
    if (num_elements == 0) return 0;
    // Create chunk
    vector_chunk_t* chunk = (vector_chunk_t*)malloc(sizeof(vector_chunk_t));
    // Check for failed creation
    if (chunk == NULL) return -1;
    // Create array of elements
    chunk->elements = (int*)malloc(num_elements * sizeof(int));
    // Check for failed creation
    if (chunk->elements == NULL) return -1;
    // Zero out initial array if zero_fill is true
    if (zero_fill) {
    	for (int i = 0; i < num_elements; i++) {
		chunk->elements[i] = 0;
    	}
    }
    // Initialize chunk values and extend the vector
    chunk->num_elements = num_elements;
    chunk->next = NULL;
    // Check if this is first chunk creation and change vector values
    if (vector->tail != NULL) {
    	vector->tail->next = chunk;
    } else {
	    vector->head = chunk;
    }
    vector->tail = chunk;
    vector->num_chunks += 1;
    vector->num_elements += num_elements;
    // return 0 to signify success
    return 0;
}


unsigned int vector_size(vector_t* vector) {
    // Find total number of elements in vector structure
    // Check if pointer is NULL
    if (vector == NULL) return 0;
    return vector->num_elements;
}


int vector_extend_array(vector_t* vector, int* array, unsigned int array_size) {
    // Check for NULL vector and 0 array size and NULL array
    if (vector == NULL) return -1;
    if (array_size == 0) return 0;
    if (array == NULL) return -1;
    // Add chunk to array and check for failure
    int success = vector_extend(vector, array_size, false);
    if (success == -1) return -1;
    // Set elements array in chunk to given array
    int index = 0;
    while (index != array_size) {
	vector->tail->elements[index] = array[index];
        index++;	
    }
    return 0;
}


int* vector_get(vector_t* vector, unsigned int index) {
    // Check for NULL vector
    if (vector == NULL) return NULL;
    // check for out of bounds
    if (index >= vector->num_elements) return NULL;
    // Loop through vector and chunks to find specified index
    if (vector->head == NULL) return NULL;
    vector_chunk_t* current_chunk = vector->head;
    while (index >= current_chunk->num_elements) {
	// Subtract from index if index is in next chunk
	index -= current_chunk->num_elements;
	current_chunk = current_chunk->next;
	if (current_chunk == NULL) break;
    }
    // Find pointer using pointer arithmetic
    int* number = current_chunk->elements + index;
    // Set pointer to NULL for memory safety
    current_chunk = NULL;
    return number;
}


int vector_set(vector_t* vector, unsigned int index, int value) {
    // check if vector is NULL
    if (vector == NULL) return -1;
    // Call vector_get to get pointer
    int* number = vector_get(vector, index);
    // Check for failure
    if (number == NULL) return -1;
    // Set new value, set pointer NULL, and return 0 to signify success
    *number = value;
    number = NULL;
    return 0;
}


int vector_coalesce(vector_t* vector) {
    // Check if vector is NULL
    if (vector == NULL) return -1;
    // Check if vector is empty
    int total_elements = vector->num_elements;
    if (total_elements == 0) return 0;
    // Check if already only one chunk
    if (vector->num_chunks == 1) return 0;
    // First, create array with all elements in it
    int array[total_elements];
    for (int i = 0; i < total_elements; i++) {
	// Get value at index value
	int* number = vector_get(vector, i);
	if (number == NULL) return -1;
	array[i] = *number;
    }
    // Second, extend array with this new array
    int success = vector_extend_array(vector, array, total_elements);
    if (success == -1) return -1;
    // Go through and free each chunk and array until we get to very last chunk
    // Very last chunk is the one we just created. Keep this one. 
    vector_chunk_t* current_chunk = NULL;
    while (vector->head->next != NULL) {
        current_chunk = vector->head;
        vector->head = vector->head->next;
        // Set pointer to NULL
        current_chunk->next = NULL;
        free(current_chunk->elements);
        current_chunk->elements = NULL;
        free(current_chunk);
    }
    // Set pointer to NULL
    current_chunk = NULL;
    // Set vector values
    vector->tail = vector->head;
    vector->num_chunks = 1;
    // Will have double the total number due to vector_extend_array call. Subtract total_elements to get original number
    vector->num_elements -= total_elements;
    // Return 0 for success
    return 0;
}
