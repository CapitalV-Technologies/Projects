/*
 * mm.c
 *
 * Name: Micah DeVore and Matthew Babish
 *
 * Micah Implemented mm_init and malloc
 * Matt Implemented free and realloc
 *
 * Simple Description of our Approach: 
 *
 * Our approach for Checkpoint one was a simple Implicit List approach. We first allocate 8 bytes of padding in the heap for alignment purposes
 * When Malloc gets called, it loops through the heap checking for the first block thats free and can fit the size of the payload
 * When free gets called, it just frees the block
 * When Realloc gets called with a greater size, it frees the old block, and calls malloc for the new block
 * We also implemented headers, footers, the flag bit for knowing if it's allocated
 * See comments below for more details on implementation
 *
 * CHECKPOINT TWO:
 *
 * Micah implemented Explicit List, segregated lists, and removal of footer in allocated blocks
 * Matt implemented Coalescing, improved realloc, added forward reallocing, and heapchecker code.
 *
 * Our approach for checkpoint two was to start with the explicit list. Thus, we made a double linked list of all free blocks within the heap.
 * Once this was successful, we expanded on it to make Segregated Lists to improve our throughput immensely.
 * By using global constants and a global array of HEADS, this makes changing the number of free-lists easy.
 * Next, we implemented coalescing within our free function to improve space utilization. 
 * We would check the previous block and next block to see if they were free. If they were, we would merge them together into one larger free block.
 * Using our heap checker, we noticed a bug where there were still two free blocks in a row within our heap (which should not happen with coalescing).
 * We realized we forgot to coalesce in our malloc function if a block was split, and fixing this, we still needed better space utilization. 
 * Thus, we improved our realloc function and implemented forward reallocating to improve space utilization. We still needed more improvement however.
 * Thus, we implemented best fit search and corrected a bug within our segregated lists logic (each lists boundaries are now powers of 2).
 * Still needing better space utilization, (but having plenty of throughput to work with), we removed our footer from allocated blocks.
 * By removing the footer, we added another allocated bit within each header telling us if the previous block was free or allocated. 
 * After this, we scored 100/100. Lastly, we cleaned up our code and submitted.
 *
 * Very difficult project, yet fun and we learned a ton! Thank you! 
 *
 */
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <stdbool.h>
#include <stdint.h>

#include "mm.h"
#include "memlib.h"

/*
 * If you want to enable your debugging output and heap checker code,
 * uncomment the following line. Be sure not to have debugging enabled
 * in your final submission.
 */
// #define DEBUG

#ifdef DEBUG
/* When debugging is enabled, the underlying functions get called */
#define dbg_printf(...) printf(__VA_ARGS__)
#define dbg_assert(...) assert(__VA_ARGS__)
#else
/* When debugging is disabled, no code gets generated */
#define dbg_printf(...)
#define dbg_assert(...)
#endif /* DEBUG */

/* do not change the following! */
#ifdef DRIVER

/* create aliases for driver tests */
#define malloc mm_malloc
#define free mm_free
#define realloc mm_realloc
#define calloc mm_calloc
#define memset mem_memset
#define memcpy mem_memcpy
#endif /* DRIVER */

/* What is the correct alignment? */
#define ALIGNMENT 16

/* rounds up to the nearest multiple of ALIGNMENT */
static size_t align(size_t x)
{
    return ALIGNMENT * ((x+ALIGNMENT-1)/ALIGNMENT);
}

// Create global variables for Segregated List
size_t INDEX = 0;

// Create global variable for removing the Footer
// This allows us to not have an epilogue in the heap
size_t* LAST_BLOCK_IN_HEAP_HEADER = NULL;

// Max number this can be is 13 due to project constraints.
// Keep lower than 12 if possible for wiggle room 
size_t NUMBER_OF_LISTS = 3;

// Create Segregated Lists
// Smaller payloads will be in the beginning of the list, larger payloads towards the end
size_t* HEADS[3];

// Create helper functions

inline size_t* find_head_helper(size_t size) {
    // Goal: Find which free-list this payload belongs to
    size_t* head = NULL;
    // Set needed variables
    INDEX = 0;
    bool head_found = false;
    // Loop through and check if payload should be in any lists before largest
    for (size_t i = 0; i < (NUMBER_OF_LISTS - 1); i++) {
        if (size < (size_t)(1 << (6 + i))) {
                head = HEADS[i];
                INDEX = i;
		head_found = true;
                break;
        }
	
    }
    // If no free-list found, set largest free list as head
    if (head_found == false) {
	head = HEADS[(NUMBER_OF_LISTS - 1)];
        INDEX = (NUMBER_OF_LISTS - 1);
    }
    // return free-list head
    return head;
}

inline void unlink_block_helper(size_t* header, size_t size) {
	// Goal: To unlink a free block from it's free-list
	size_t* prev_block = (size_t*)*(header + 1);
        size_t* next_block = (size_t*)*(header + 2);

        // Find which list free block is in
        find_head_helper(size);

        // Set previous block pointing to next block
        if (prev_block != NULL) {
               *(prev_block + 2) = (size_t)next_block;
        } else {
               // if previous block is NULL, means previous block was head, so update the HEADS array
               HEADS[INDEX] = next_block;
        }
	// Set next_block pointing to prev_block, if next block exists
        if (next_block != NULL) {
               *(next_block + 1) = (size_t)prev_block;
        }
}

inline void add_free_block_helper(size_t* head, size_t* header) {
	// Goal: Add free block to correct free list 
	// Check if this is first block being freed in list
        if (head == NULL) {
                // Make first block head
                HEADS[INDEX] = header;
                // Make first byte after header point to previous free block in list
                *(header + 1) = (size_t)NULL;
                // Make second byte after header point to next block in list.
                *(header + 2) = (size_t)NULL;
        } else {
		// Insert free block into head of list, update pointers, and update old head's pointers
                size_t* first_free_block = head;
                HEADS[INDEX] = header;
                *(header + 1) = (size_t)NULL;
                *(header + 2) = (size_t)first_free_block;
                *(first_free_block + 1) = (size_t)header;
        }
}

inline bool check_if_prev_allocated(size_t* header) {
	// Goal of this function is to check if the previous block is allocated or free
	// We are using the second to last bit of the address as our allocator bit for the previous block
	if ((*header & 2) == 2) {
		//Means the previous block is allocated
		return true;
	} else {
		//Means the previous block is free
		return false;
	}
}

inline size_t get_block_size(size_t* header) {
	// Goal: Get block size and clear all possible alloctor bits
	return (*header & ~3);
}

inline void set_header_prev_bit(bool yes, size_t* header) {
	// Goal: Set previous allocator bit based on whether previous block is free or previous block is allocated
	if (yes) {
		// Set allocator bit to one
		*header = (*header | 2);
	} else {
		// Set allocator bit to zero
		*header = (*header & ~2);
	}
}

/*
 * Initialize: returns false on error, true on success.
 */

bool mm_init(void)
{
    // Micah Implementation

    // Reset free list every time mm_init gets called
    for (size_t i = 0; i < NUMBER_OF_LISTS; i++) {
	HEADS[i] = NULL;
    }

    // Reset global Variables
    INDEX = 0;
    LAST_BLOCK_IN_HEAP_HEADER = NULL;

    // Add 8 bytes of padding to beginning of heap for alignment purposes
    void* heap = mem_sbrk(8);
    if (heap == (void*)-1) {
	    return false;
    } else {
	    return true;
    }
}

/*
 * malloc
 */
void* malloc(size_t size)
{
    // Micah Implementation
    
    // Check if size is 0
    if (size == 0) return NULL;

    // First, align size to a multiple of ALIGNMENT (16)
    // Add 8 for header only. WE ARE REMOVING THE FOOTER!
    size_t size_with_padding = align(size + 8);
   
    // For explicit list logic, make sure payload is at least 32 bytes
    // Free block must be at least 32 bytes
    if (size_with_padding < 32) {
	size_with_padding = 32;
    }

    // Find correct head to use based on payload size, which also sets global INDEX variable
    // This is implemented our segregated list logic
    size_t* head = find_head_helper(size_with_padding);

    // Implement Explicit List Approach. Loop through only free blocks using head pointer. 
    if (head != NULL) {
    	size_t* current = (size_t*)head;
	// If head is not NULL, this means we have potential free blocks to use
	
    	// REMINDER: size_t pointer will jump 8 bytes for a plus 1 in pointer addition
    	// REMINDER: unsigned char pointer will jump 1 byte for a plus 1 in pointer addition
	
	// Implement best fit search for space utilization
	size_t* best_block = NULL;
	size_t smallest_diff = -1;
	int count = 0;
	
	// Set a limit to number of free blocks we check. That way our throughput doesn't completely drop.
	// Can play around with limit to maximize space utilization 
	while (current != NULL && count < 30) {
    		if (get_block_size(current) >= size_with_padding) {
        		size_t diff = get_block_size(current) - size_with_padding;
        		if (diff < smallest_diff) {
            			best_block = current;
            			smallest_diff = diff;
        		}
    		}
    		current = (size_t*)*(current + 2);
    		count++;
	}
	
	// Check if we found a best fit
	if (best_block != NULL) {
		current = best_block;
	}


    	// If we didn't find a free block yet, just keep looping through free list till we do or reach the end
    	while (current != NULL) {
		if ((get_block_size(current)) < size_with_padding) {
			current = (size_t*)*(current + 2);
		} else {
			size_t difference = get_block_size(current) - size_with_padding;
			size_t* header = current;
			// Keep track of original size for unlinking lists function
			size_t original_size = get_block_size(current);
			// If difference is less than 32 bytes, don't split block.
			if (difference < 32) {
				// Set header
				// Check if previous is allocated or not
				bool yes = check_if_prev_allocated(header);
				// set header
				*header = (size_with_padding + difference) | 1;
				// Set prev allocator bit
				set_header_prev_bit(yes,header);

				void* start = (void*)(header + 1);
				// NO FOOTER for this allocated block

				// Now, we need to update the header of the next block to show that the previous block is allocated
				// Check first if it's within the heap
				size_t* next_block = header + ((size_with_padding + difference) / 8);
				if ((unsigned char*)next_block < (unsigned char*)mem_heap_hi()) {
					set_header_prev_bit(true, next_block);
				}

				unlink_block_helper(current, original_size);
				return start;
			} else {
					// Split block into allocated and free blocks
					// Set header
					bool yes = check_if_prev_allocated(header);
                                	*header = size_with_padding | 1;
					set_header_prev_bit(yes,header);
                                	void* start = (void*)(header + 1);
                                	// DO NOT set footer of this allocated block

					//Get new free block
                                	size_t* new_free_block = header + (size_with_padding/8);

					// Still use original_size here since your unlinking orginal free block
					// Want to unlink free list of initial *current size first, before adding new free block
					unlink_block_helper(current, original_size);

					// Set header
					// Mark as allocated so that when we call free on this block, it works
					*new_free_block = difference | 1;
					// We know previous block is allocated, so set allocator bit
					set_header_prev_bit(true, new_free_block);
					
					// Check if this new free block is the last block in heap
                                        if ((unsigned char*)new_free_block + get_block_size(new_free_block) == (unsigned char*)mem_heap_hi() + 1) {
                                                LAST_BLOCK_IN_HEAP_HEADER = new_free_block;
                                        }
					
					// go to footer
					size_t* footer_new_free_block = new_free_block + ((difference / 8) - 1);

					//Only store size in footer of free block
					*footer_new_free_block = difference;
					

					// Now, we need to update the header of the next block to show that the previous block is allocated
                                	size_t* next_block = footer_new_free_block + 1;
					if ((unsigned char*)next_block < (unsigned char*)mem_heap_hi()) {
                                		set_header_prev_bit(false, next_block);
					}
					mm_checkheap(__LINE__);

					// This will implement coalescing and free if needed
					free(new_free_block + 1);
					return start;
			}
		}
    	}
    }

    // If head is NULL, this means we have no free blocks. Thus, we must expand the heap.
    // OR if we don't find any usable free blocks, must expand heap
    
    size_t* heap_pointer = (size_t*)mem_sbrk(size_with_padding);
    if (heap_pointer == (void*)-1) {
            return NULL;
    }
    // Remember address to start of allocated block
    void* start = (void*)(heap_pointer + 1);

    bool prev_block_allocated = false;
    if (LAST_BLOCK_IN_HEAP_HEADER != NULL) {
	// Check if last block in heap is allocated or free
	if ((*LAST_BLOCK_IN_HEAP_HEADER % 2) == 1) {
		//Means last block is allocated
		prev_block_allocated = true;
	}
    } else {
	// Means this is first block in heap. 
	// Want to set prev_block allocator bit as true so we don't coalesce into padding or earlier addresses before the heap!
	prev_block_allocated = true;
    }

    // Set header to size and allocated
    *heap_pointer = size_with_padding | 1;
    set_header_prev_bit(prev_block_allocated, heap_pointer);

    // Again, don't set footer since this is an allocated block.

    // Set last block
    LAST_BLOCK_IN_HEAP_HEADER = heap_pointer;
 
    return start;
}

/*
 * free
 */
void free(void* ptr)
{
	// Start of Matt's implementation
	// First need to check if ptr is NULL. If it is, just return
	if (ptr == NULL) {
		return;
	}
        //mm_checkheap(__LINE__);
		
	// Get pointer to the header (8 bytes before the payload)
	size_t* header = (size_t*)ptr - 1;

	// Read value from the header
	size_t header_value = *header;

	// Check if block has already been freed
	// We do this so we don't potentially mess up any of our pointers by double freeing.
	if (header_value % 2 == 0) {
		return;
	}

	// Calculate the block size by removing both allocator bits
	size_t block_size = get_block_size(header);

	// Mark the block as free in the header
	// Check value of prev_allocator bit 
	bool yes = check_if_prev_allocated(header);
	*header = block_size;
	set_header_prev_bit(yes, header);

	// Now need to find the footer (at the end of the block, 8 bytes from the end)
	size_t* footer = (size_t*)((unsigned char*)header + block_size - 8);

	// Only store size in footer of free block
	*footer = block_size;
	
	// Start of coalescing code (Matt's Implementation)
	// First check if previous block exists and is free
	bool prev_free = false;
	size_t prev_size = 0;
	if ((unsigned char*)header > (unsigned char*)mem_heap_lo() + 8) {
		// Get previous block's footer, which is right before our header
		size_t* prev_footer = header - 1;
		// Only stored sizes in footers, so this is okay
		size_t prev_footer_value = *prev_footer;

		bool yes = check_if_prev_allocated(header);

		// Check if the previous block is free (even number means free)
		if (!yes) {
			prev_free = true;
			prev_size = prev_footer_value;
		}
	}

	// Check if next block exists and is free
	bool next_free = false;
	size_t next_size = 0;

	// Calculate where the next block's header should be
	size_t* next_header = (size_t*)((unsigned char*)header + block_size);

	// Make sure next block is within the heap
	if ((unsigned char*)next_header < (unsigned char*)mem_heap_hi()) {
		size_t next_header_value = *next_header;

		// Check if the next block is free
		if (next_header_value % 2 == 0) {
			next_free = true;
			next_size = get_block_size(next_header);
		}
	}
	
	// If either neighbor is free, we need to merge and remove them from free lists first
	if (prev_free) {
		// Remove previous block from its free list
		size_t* prev_header = (size_t*)((unsigned char*)header - prev_size);

		// Unlink from list
		unlink_block_helper(prev_header, prev_size);

		// Merge with previous blocks
		header = prev_header;
		bool yes = check_if_prev_allocated(header);
		block_size += prev_size;
		*header = block_size;
		set_header_prev_bit(yes, header);
	}

	if (next_free) {
		// Remove next block from its free list
		size_t* next_header = (size_t*)((unsigned char*)header + block_size);

		// Unlink from list
		unlink_block_helper(next_header, next_size);

		// Merge with next block
		bool yes = check_if_prev_allocated(header);
		block_size += next_size;
		*header = block_size;
		set_header_prev_bit(yes,header);
	}

	// Update footer of merged block
	footer = (size_t*)((unsigned char*)header + block_size - 8);

	// Only store size in footers (no allocator bits)
	*footer = block_size;

	// Find free list we need to add this new free block to
    	size_t* head = find_head_helper(block_size);
	add_free_block_helper(head, header);

	// Now we need to set the next block prev_allocator bit as 0
	size_t* next_block = footer;

	// First check if it is within the heap
	if (((unsigned char*)next_block + 8) < (unsigned char*)mem_heap_hi()) {
		// We know previous block is free, so call helper function with false
		set_header_prev_bit(false, ((size_t*)next_block + 1));
	}

	// Check if this new free block is the last block in heap
        if ((unsigned char*)header + get_block_size(header) == (unsigned char*)mem_heap_hi() + 1) {
        	LAST_BLOCK_IN_HEAP_HEADER = header;
        }
}

/*
 * realloc
 */
void* realloc(void* oldptr, size_t size)
{
	// If ptr is NULL, we return malloc
	// If size is 0, we call free and return NULL
	if (oldptr == NULL) {
		return malloc(size);
	} else if (size == 0) {
		free(oldptr);
		return NULL;
	}

	mm_checkheap(__LINE__);

	// Now start realloc logic
	
	// First we need to get the current block size by going into the header of oldptr
	size_t* old_header = (size_t*)oldptr - 1;
	size_t old_block_size = get_block_size(old_header);

	// Now need to calculate what the new block size needs to be
	// Add 8 bytes for header
	size_t new_size_with_padding = align(size + 8);

	// For explicit list logic, make sure payload is at least 32 bytes
    	if (new_size_with_padding < 32) {
        	new_size_with_padding = 32;
    	}	

	// If the new size is less than or equal to the old size, we don't need to realloc
	// However, if the new size is bigger than the old size, then we do need to realloc
	if (new_size_with_padding <= old_block_size) {
		// New size fits in old block
		// First calculate leftover space
		size_t leftover = old_block_size - new_size_with_padding;

		// Only split if leftover is big enough (at least 32 bytes)
		if (leftover >= 32) {
			// Split the block
			// Update current block to smaller size
			bool yes = check_if_prev_allocated(old_header);
			*old_header = new_size_with_padding | 1;
			set_header_prev_bit(yes, old_header);
			
			// Do not update footer of allocated block

			// Create new free block with leftover space
			size_t* new_free_header = (size_t*)((unsigned char*)old_header + new_size_with_padding);
			// Set as allocated so we can call our free function on it
			*new_free_header = leftover | 1;
			set_header_prev_bit(true, new_free_header);

			// Set footer of new free block
			size_t* new_free_footer = (size_t*)((unsigned char*)new_free_header + leftover - 8);
			// Footers are always size only
			*new_free_footer = leftover;
			
			// Now free it (this will add it to the free list and coalesce if needed
			void* new_free_payload = (void*)(new_free_header + 1);
			free(new_free_payload);
		}
		// If leftover is too small, just reuse the whole block (dont split)
		return oldptr;

	} else if (new_size_with_padding > old_block_size) {
		// Try forward reallocation to expand into next block first (For space utilizatioin)
		size_t* next_header = (size_t*)((unsigned char*)old_header + old_block_size);

		bool can_expand = false;
		size_t next_size = 0;

		if ((unsigned char*)next_header < (unsigned char*)mem_heap_hi()) {
			size_t next_header_value = *next_header;

			// Check if the next block is free
			if (next_header_value % 2 == 0) {
				next_size = get_block_size(next_header);

				// Check if current block plus next block will be big enough
				if (old_block_size + next_size >= new_size_with_padding) {
					// We can expand into next block if true
					can_expand = true;
				}
			}
		}

		if (can_expand) {
			// Remove next block from its free list
			unlink_block_helper(next_header, next_size);

			// Expand current block
			size_t new_block_size = old_block_size + next_size;
			size_t leftover = new_block_size - new_size_with_padding;

			if (leftover >= 32) {
				// Split what we need, free the rest
				bool yes = check_if_prev_allocated(old_header);
				*old_header = new_size_with_padding | 1;
				set_header_prev_bit(yes,old_header);
				
				// DO not set Footer of allocated block

				// Create leftover free block
				size_t* leftover_header = (size_t*)((unsigned char*)old_header + new_size_with_padding);
				*leftover_header = leftover | 1;
				// We know previous block is allocated, so set that bit
				set_header_prev_bit(true, leftover_header);
				size_t* leftover_footer = (size_t*)((unsigned char*)leftover_header + leftover - 8);
				// All free blocks are size only
				*leftover_footer = leftover;
				
				//Free the leftover
				void* leftover_payload = (void*)(leftover_header + 1);
				free(leftover_payload);
			} else {
				// Use the whole merged block
				bool yes = check_if_prev_allocated(old_header);
				*old_header = new_block_size | 1;
				set_header_prev_bit(yes, old_header);
					
				// Do not set footer
				
				// Check if this new free block is the last block in heap
                                if ((unsigned char*)old_header + get_block_size(old_header) == (unsigned char*)mem_heap_hi() + 1) {
                                	LAST_BLOCK_IN_HEAP_HEADER = old_header;
                                }
				
				// We need to set our next next block's previous allocator bit.
				size_t* next_next_block = old_header + (new_block_size / 8);
				// First check if it is within the heap
        			if ((unsigned char*)next_next_block < (unsigned char*)mem_heap_hi()) {
                			// We know previous block is true, so call helper function with true
                			set_header_prev_bit(true, next_next_block);
        			}
			}
			
			// Now return same pointer. No need to copy
			return oldptr;
		}

		// Cant expand in place, so we just do normal malloc, copy, and free
		void* newptr = malloc(size);
		if (newptr == NULL) {
			return NULL;
		}

		// Now calculate how big the old payload is
		size_t old_payload_size = old_block_size - 8;

		// Now figure out how many bytes to copy, which is the minimum of the old payload size and the new size
		size_t bytes_to_copy = size;
		if (size > old_payload_size) {
			bytes_to_copy = old_payload_size;
		}

		// Copy the necessary amount bytes to the new block
		memcpy(newptr, oldptr, bytes_to_copy);

		// Free the old block
		free(oldptr);

		// Return the new block
		return newptr;
	}
	// If something went wrong return NULL
	return NULL;
}

/*
 * calloc
 * This function is not tested by mdriver, and has been implemented for you.
 */
void* calloc(size_t nmemb, size_t size)
{
    void* ptr;
    size *= nmemb;
    ptr = malloc(size);
    if (ptr) {
        memset(ptr, 0, size);
    }
    return ptr;
}

/*
 * Returns whether the pointer is in the heap.
 * May be useful for debugging.
 */
static bool in_heap(const void* p)
{
    return p <= mem_heap_hi() && p >= mem_heap_lo();
}

/*
 * Returns whether the pointer is aligned.
 * May be useful for debugging.
 */
static bool aligned(const void* p)
{
    size_t ip = (size_t) p;
    return align(ip) == ip;
}

/*
 * mm_checkheap
 */
bool mm_checkheap(int lineno)
{
#ifdef DEBUG
    /* Write code to check heap invariants here */
    /* IMPLEMENT THIS */
	// Check 1: verify header/footer consistency for all blocks
	size_t* check_ptr = (size_t*)mem_heap_lo() + 1;
	while (check_ptr <= (size_t*)mem_heap_hi()) {
		size_t header_value = *check_ptr;
		size_t block_size = get_block_size(check_ptr);
		bool is_allocated = (header_value % 2 == 1);

		// Make sure block size is valid
		if (block_size < 32 || block_size % 16 != 0) {
			printf("ERROR line %d: Invalid block size %zu at %p\n", lineno, block_size, check_ptr);
			return false;
		}

		// Check that footer matches header ONLY for free blocks
		if (!is_allocated) {
			size_t* footer = (size_t*)((unsigned char*)check_ptr + block_size - 8);
			if (footer <= (size_t*)mem_heap_hi() && *footer != block_size) {
				printf("ERROR line %d: Header/footer mismatch at %p. Header = %zu, Footer = %zu\n", lineno, check_ptr, header_value, *footer);
				return false;
			}
		}

		check_ptr += (block_size / 8);
	}
	// Check 2: Check to make sure all free blocks are surrounded by Allocated blocks
	size_t* heap_pointer = (size_t*)mem_heap_lo();

	// Add 1 for the paddig
	heap_pointer += 1;
	// Check if first block in heap is allocated or free
	bool prev_allocated = false;
	if (*heap_pointer % 2 == 1) {
		prev_allocated = true;
	}
	heap_pointer += (*heap_pointer / 8);
	while (heap_pointer < (size_t*)mem_heap_hi()) {
		// check if block is free or allocated
		if (*heap_pointer % 2 == 0) {
			// Means this block is free. Thus, check if previous block is free as well
			if (prev_allocated == false) {
				printf("Error: Two free blocks in a row!");
			}
			prev_allocated = false;
			heap_pointer += (*heap_pointer / 8);
		} else {
			prev_allocated = true;
			heap_pointer += (*heap_pointer / 8);
		}
	}

	// Check 3: verify free list consistency
	for (size_t i = 0; i < NUMBER_OF_LISTS; i++) {
		size_t* current = HEADS[i];
		int count = 0;

		while (current != NULL) {
			// Check for cycles (if checked more than 1000 blocks, probably a cycle)
			if (count > 1000) {
				printf("ERROR line %d: Free list %zu appears to have a cycle\n", lineno, i);
				return false;
			}

			// Make sure this block is actually in the heap
			if (!in_heap(current)) {
				printf("ERROR line %d: Free list %zu contains block %p outside heap\n", lineno, i, current);
				return false;
			}

			// Make sure this block is actually free
			if (*current % 2 == 1) {
				printf("ERROR line %d: Free list %zu contains allocated block %p\n", lineno, i, current);
				return false;
			}

			// Move to next block in free list
			current = (size_t*)*(current + 2);
		}
	}
#endif /* DEBUG */
    return true;
}
