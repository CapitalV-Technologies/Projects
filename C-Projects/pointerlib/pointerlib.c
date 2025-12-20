#include "pointerlib.h"


/*
This is the implementation of the functions in pointerlib.h. 
Please read the comments in pointerlib.h before you start working on this file.
*/

// Memory preallocated for 100 nodes; DO NOT MODIFY THIS ARRAY
list_node_t NODE_LIST[MAX_NODE_LIST_SIZE] = {0};


int swap_int_values(int* a, int* b) {
     // Check to make sure pointers are non-NULL values
     if ((a != NULL) && (b != NULL)) {
         // Using temp variable, swap pointed to values of a and b
         int temp = *a;
         *a = *b;
         *b = temp;
         return 0;
     }
     return -1;
}


list_node_t* create_node(int data) {
     // Loop through Node list
     int index = 0;
     while (index < MAX_NODE_LIST_SIZE) {
         // Once we find a non-used Node, set data, used, and next
         if (NODE_LIST[index].used != true) {
                 NODE_LIST[index].data = data;
                 NODE_LIST[index].used = true;
                 NODE_LIST[index].next = NULL;
                 // end while loop by returning a pointer to the node
                 list_node_t* new_node = &NODE_LIST[index];
                 return new_node;
         }
         index++;
     }
     // If all nodes already used, return NULL
     return NULL;
}

int destroy_node(list_node_t* node) {
    // Check if pointer is not Null
    if (node != NULL) {
	// Reset data
	// Set used to false
	node->data = 0;
	node->used = false;
	node->next = NULL;
	// return 0 to show reset completed
	return 0;
    }
    // If Node is NULL, return -1
    return -1;
}

int link_nodes(list_node_t* node1, list_node_t* node2) {
    // Check if node1 is non-NULL
    if (node1 != NULL) {
	// Set next to address of node2
	node1->next = node2;
	// return 0 to signify success
	return 0;
    }
    //return -1 to signify failure
    return -1;
}

int list_length(list_node_t* head) {
    // create variable to store total nodes
    int total_nodes = 0;
    // Check if start node is NULL
    if (head != NULL) {
	total_nodes += 1;
	list_node_t* current = head;
	// Loop through Linked List till we find a NULL node.
	while (current->next != NULL) {
		total_nodes += 1;
		current = current->next;
	}
    }
    // return total nodes
    return total_nodes;
}

int append_new_node(list_node_t* head, int data) {
    // Check if head is non-Null
    if (head != NULL) {
	// Create new node
    	list_node_t* new_node = create_node(data);
    	// Check for unsuccessful creation of new node
    	if (new_node == NULL) {
            return -1;
    	}
	list_node_t* current = head;
	// Iterate through linked list
	while (current->next != NULL) {
		current = current->next;
	}
	// One we find last node, set next to new node.
	// return 0 to indicate success
	current->next = new_node;
	return 0;
    }
    // return -1 if head is NULL to signify unsuccessful
    return -1;
}

int list_statistics(list_node_t* head, double* avg, int* min, int* max, int* sum) {
    // Check if head is non_NULL
    if (head != NULL) {
	// set pointers' pointed to values to head data initially
	*avg = head->data;
	*min = head->data;
	*max = head->data;
	*sum = head->data;
	// Check if next node is non-NULL
	if (head->next != NULL) {
		list_node_t* current = head->next;
		// Iterate through Linked List and update each pointers' pointed to values based on node data
		while (current != NULL) {
			*avg += current->data;
			if (*min > current->data) (*min = current->data);
        		if (*max < current->data) (*max = current->data);
        		*sum += current->data;
			current = current->next;
		}
	}
	// Find average by using list_length function, won't return 0 since we know head is non-NULL
	*avg = (*avg / list_length(head));
	// Return 0 to indicate success
	return 0;
    }
    // Return -1 to indicate failure since head was NULL
    return -1;
}

list_node_t* list_find(list_node_t* head, int target) {
    // Check if head is non-NULL
    if (head != NULL) {
	list_node_t* current = head;
	// Iterate through Linked List
	while (current != NULL) {
		// If node's data is target, return pointer of that node
		if (target == current->data) {
			return current;
		}
		current = current->next;
	}
    }
    // If head is NULL or target not found, return NULL
    return NULL;
}

list_node_t* list_get_index(list_node_t* head, int index) {
    // Check if head is non-NULL
    if (head != NULL) {
	list_node_t* current = head;
	int ind = 0;
	// Iterate through linked list
	// Once target index is found, return pointer to node
	while (current != NULL) {
		if (ind == index) {
			return current;
		}
		ind += 1;
		current = current->next;
	}
    }
    // Return NULL if index out of bounds or empty linked list
    return NULL;
}

list_node_t* list_remove_index(list_node_t* head, int index) {
    // Check if head is non-NULL
    if (head != NULL) {
	list_node_t* previous = head;    
	// If index is 0, destroy head node, remove from linked list, and return new list
	if (index == 0) {
		head = head->next;
		destroy_node(previous);
		return head;
	}
	// Check if next node is not NULL
	if (head->next != NULL) {
		list_node_t* current = head->next;
		int ind = 1;
		// Iterate through linked list
		while (current != NULL) {
			// If index found, destroy corresponding node and remove from linked list, return new list
			if (ind == index) {
				previous->next = current->next;
				destroy_node(current);
				return head;
			}
			previous = current;
			current = current->next;
			ind += 1;
		}
    	}
    }
    // Return orginal list if index out of bounds or list is empty
    return head;
}

list_node_t* list_insert_index(list_node_t* head, int index, int data) {
    list_node_t* current = head;
    // Case 1: Index is 0 (new node becomes head node)
    if (index == 0) {
	current = create_node(data);
	// Check if new Node creation was succesful
	if (current != NULL) {
		// Set new node as head of linked list
		current->next = head;
		head = current;
		return head;
	// Return NULL if unsuccessful
	} else return NULL;
    }
    // Case 2: Index is anything else
    // Check to make sure head is not NULL
    if (head != NULL) {
    	current = head;
	int ind = 1;
	// Iterate through linked list
	while (current != NULL) {
		// Check if given index is found
		if (ind == index) {
			list_node_t* new_node = create_node(data);
			// Check if new node creation was successful
			if (new_node != NULL) {
				// Insert node into linked list at given index
				new_node->next = current->next;
				current->next = new_node;
				return head;
			// Return NULL if unsuccessful
			} else return NULL;
		}
		current = current->next;
		ind += 1;
	}
    }
    // Return NULL if index is out of bounds
    return NULL;
}

int list_insert_index_hard(list_node_t** head, int index, int data) {
    // We don't want our given head pointer (pointer to a pointer) to change
    // Check if given head pointer is NULL, if so return -1
    if (head == NULL) return -1;
    // Find the head of the linked list by defrencing given head pointer
    // Use previous function with head of linked list to insert a new node
    list_node_t* head2 = list_insert_index(*head, index, data);
    // Check if insertion was successful
    // If it was, make given head pointer point to (potentially new) returned head (pointer) of linked list
    // If it wasn't, return -1
    if (head2 != NULL) {
    	*head = head2;
    	// return 0 to signify a successful operation
    	return 0;
    } else return -1;
}
