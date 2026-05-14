#include "channel.h"

// Iterates over all semaphores registered in the channel's select_sems list and posts each one
// This wakes up any channel_select calls that are currently blocked waiting on this channel to become ready
static void notify_select_waiters(chan_t* channel) {
    list_node_t* node = list_begin(channel->select_sems);
    while (node != NULL) {
    	sem_t* sem = (sem_t*) list_data(node);
	sem_post(sem);
	node = list_next(node);
    }
}

// Attempts one nonblocking pass over all channels in list
// Returns SUCCESS or an error code if any operation succeeds or fails
// Returns WOULDBLOCK if no channel was ready

static enum chan_status try_select(size_t channel_count, select_t* channel_list, size_t* selected_index) {
    for (size_t i = 0; i < channel_count; i++) {
    	chan_t* channel = channel_list[i].channel;

	// Check if this channel is closed before attempting operation
	pthread_mutex_lock(&channel->lock);
	if (channel->is_open == false) {
	    pthread_mutex_unlock(&channel->lock);
	    *selected_index = i;
	    return CLOSED_ERROR;
	}
	pthread_mutex_unlock(&channel->lock);

	// Attempt the nonblocking send or receive on this channel
	enum chan_status result = OTHER_ERROR;
	if (channel_list[i].is_send) {
	    result = channel_send(channel, channel_list[i].data, false);
	} else {
	    result = channel_receive(channel, &channel_list[i].data, false);	
	}

	// If the operation succeeded or hit a real error, we are done
	if (result != WOULDBLOCK) {
	    *selected_index = i;
	    return result;
	}
    }
    return WOULDBLOCK;
}

// Creates a new channel with the provided size and returns it to the caller
// A 0 size indicates an unbuffered channel, whereas a positive size indicates a buffered channel
chan_t* channel_create(size_t size)
{
    /* IMPLEMENT THIS */
	
    // Create initial chan_t struct using Malloc
    // Can find chan_t struct in channel.h
    chan_t* channel = malloc(sizeof(chan_t));
   
    //Check for failed creation
    if (channel == NULL) {
	perror("Channel creation failed");
	return NULL;
    }

    // Initialize all values within struct
    channel->is_open = true;
    channel->buffer = buffer_create(size);

    //Check for failed creation
    if (channel->buffer == NULL) {
	free(channel);
	perror("buffer_create Failed");
	return NULL;
    }
    
    //NOTE: May need to check if these fail, but leave for now
    pthread_mutex_init(&channel->lock, NULL);
    pthread_cond_init(&channel->condition_add, NULL);
    pthread_cond_init(&channel->condition_take, NULL);

    // Initialize the select semaphore list so channel_select can register semaphores with
    // this channel when it needs to wait on it
    channel->select_sems = list_create();

    return channel;
}

// Writes data to the given channel
// This can be both a blocking call i.e., the function only returns on a successful completion of send (blocking = true), and
// a non-blocking call i.e., the function simply returns if the channel is full (blocking = false)
// In case of the blocking call when the channel is full, the function waits till the channel has space to write the new data
// Returns SUCCESS for successfully writing data to the channel,
// WOULDBLOCK if the channel is full and the data was not added to the buffer (non-blocking calls only),
// CLOSED_ERROR if the channel is closed, and
// OTHER_ERROR on encountering any other generic error of any sort
enum chan_status channel_send(chan_t* channel, void* data, bool blocking)
{
    /* IMPLEMENT THIS */
	
    // Non_blocking Case
    if (blocking == false) {
	
	// Grab lock first
	// Still must grab lock becuase if we don't, data race
	// Could use tryLock here maybe...
	pthread_mutex_lock(&channel->lock);

    	// Then check if channel is closed 
    	if (channel->is_open == false) {
		pthread_mutex_unlock(&channel->lock);
		return CLOSED_ERROR;
    	}

	// Check if we can add to buffer
	bool success = buffer_add(data, channel->buffer);
	if (success == true) {
		// If we can, signal condition_take so threads know they can take from buffer
		// then unlock
		pthread_cond_signal(&channel->condition_take);
		// Notify any channel_select calls waiting on this channel that a message was added
		// and they may now be able to receive
		notify_select_waiters(channel);
		pthread_mutex_unlock(&channel->lock);
		return SUCCESS;
	} else {
		// If we can't just unlock and return since we aren't blocking
		pthread_mutex_unlock(&channel->lock);
		return WOULDBLOCK;
	}
    }

    // Blocking case
    
    // Grab lock first. 
    pthread_mutex_lock(&channel->lock);

    // Now, check if our buffer is full (meaning we can't add to the buffer)
    while (buffer_capacity(channel->buffer) == buffer_current_size(channel->buffer)) {
	// If it is, first check if channel is closed
	// We don't wannt to put thread to sleep if channel is closed (instead just return)
	// Also we are checking it in case channel got closed while thread is sleeping 
	if (channel->is_open == false) {
        	// If it is, unlock and return error
        	pthread_mutex_unlock(&channel->lock);
        	return CLOSED_ERROR;
    	}
	// Now wait for signal to wake up, either due to channel not being full or channel_close
	pthread_cond_wait(&channel->condition_add, &channel->lock);
    }
	
    // If buffer is not full
    // First, check if channel is closed
    if (channel->is_open == false) {
        // If it is, unlock and return error
        pthread_mutex_unlock(&channel->lock);
        return CLOSED_ERROR;
    }

    //If not, add data and signal that we added data
    buffer_add(data, channel->buffer);
    pthread_cond_signal(&channel->condition_take);
    // Notify any channel_select calls waiting on this channel that a message was added and they
    // may now be able to receive
    notify_select_waiters(channel);
    pthread_mutex_unlock(&channel->lock);
        
    return SUCCESS;
}

// Reads data from the given channel and stores it in the function’s input parameter, data (Note that it is a double pointer).
// This can be both a blocking call i.e., the function only returns on a successful completion of receive (blocking = true), and
// a non-blocking call i.e., the function simply returns if the channel is empty (blocking = false)
// In case of the blocking call when the channel is empty, the function waits till the channel has some data to read
// Returns SUCCESS for successful retrieval of data,
// WOULDBLOCK if the channel is empty and nothing was stored in data (non-blocking calls only),
// CLOSED_ERROR if the channel is closed, and
// OTHER_ERROR on encountering any other generic error of any sort
enum chan_status channel_receive(chan_t* channel, void** data, bool blocking)
{
    /* IMPLEMENT THIS */

    // Follow same format as channel_send with slight changes

    // Non_blocking Case
    if (blocking == false) {
	
	// Grab lock first
	pthread_mutex_lock(&channel->lock);
	

        // check if channel is closed
        if (channel->is_open == false) {
		pthread_mutex_unlock(&channel->lock);
                return CLOSED_ERROR;
        }

        
        // Check if we can take from the buffer
        void* info = buffer_remove(channel->buffer);
        if (info != BUFFER_EMPTY) {
               // If we can, signal that we took from buffer (meaning another thread can add to it)
		*data = info;
		pthread_cond_signal(&channel->condition_add);
		// Notify any channel_select calls waiting on this channel that a slot opened up
		// and they may now be able to send
		notify_select_waiters(channel);
                pthread_mutex_unlock(&channel->lock);
                return SUCCESS;
        } else {
                // If we can't just unlock and return since we are non-blocking
                pthread_mutex_unlock(&channel->lock);
                return WOULDBLOCK;
        }
    }
    
    //Blocking case

    // Grab lock
    pthread_mutex_lock(&channel->lock);
    
    // Check if buffer is empty
    while (buffer_current_size(channel->buffer) == 0) {
	// If it is, first check if channel is closed
	if (channel->is_open == false) {
                // If it is, unlock everything and return error
                pthread_mutex_unlock(&channel->lock);
                return CLOSED_ERROR;
        }
	// Now wait for buffer to become-non empty
        pthread_cond_wait(&channel->condition_take, &channel->lock);
    }

    // If buffer not empty, first check if channel is closed
    if (channel->is_open == false) {
        // If closed, unlock everything and return error
        pthread_mutex_unlock(&channel->lock);
        return CLOSED_ERROR;
    }

    // Take from buffer and signal that we took from buffer (another thread can now add to it)
    void* info = buffer_remove(channel->buffer);
    *data = info;
    pthread_cond_signal(&channel->condition_add);
    // Notify any channel_select calls waiting on this channel that a slot opened up and they may now be able to send
    notify_select_waiters(channel);
    pthread_mutex_unlock(&channel->lock);
    
    return SUCCESS;
}

// Closes the channel and informs all the blocking send/receive/select calls to return with CLOSED_ERROR
// Once the channel is closed, send/receive/select operations will cease to function and just return CLOSED_ERROR
// Returns SUCCESS if close is successful,
// CLOSED_ERROR if the channel is already closed, and
// OTHER_ERROR in any other error case
enum chan_status channel_close(chan_t* channel)
{
    /* IMPLEMENT THIS */

    // Grab lock
    pthread_mutex_lock(&channel->lock);

    // Check if channel is already closed
    if (channel->is_open == false) {
	pthread_mutex_unlock(&channel->lock);
	return CLOSED_ERROR;
    }
	
    // If not, set channel closed
    channel->is_open = false;
    
    // Wake up all blocked threads with a broadcast
    // NOTE: changed to CV's from semaphores here because with semaphores you don't know how many threads are blocked...
    // So you don't know how many sem_posts you should do...
    pthread_cond_broadcast(&channel->condition_add);
    pthread_cond_broadcast(&channel->condition_take);
    // Notify any channel_select calls waiting on this channel that the channel is now closed so they can return CLOSED_ERROR
    notify_select_waiters(channel);
    // Unlock and return
    pthread_mutex_unlock(&channel->lock);

    return SUCCESS;
}

// Frees all the memory allocated to the channel
// The caller is responsible for calling channel_close and waiting for all threads to finish their tasks before calling channel_destroy
// Returns SUCCESS if destroy is successful,
// DESTROY_ERROR if channel_destroy is called on an open channel, and
// OTHER_ERROR in any other error case
enum chan_status channel_destroy(chan_t* channel)
{
    /* IMPLEMENT THIS */

    // Grab lock
    pthread_mutex_lock(&channel->lock);

    // Check if channel is still open
    if (channel->is_open == true) {
	pthread_mutex_unlock(&channel->lock);
	return DESTROY_ERROR;
    }

    //unlock
    pthread_mutex_unlock(&channel->lock);

    //Free/destroy everythig within channel
    pthread_mutex_destroy(&channel->lock);
    pthread_cond_destroy(&channel->condition_add);
    pthread_cond_destroy(&channel->condition_take);
    buffer_free(channel->buffer);

    // Free the select semaphore list before freeing the channel itself
    list_destroy(channel->select_sems);

    free(channel);
    
    return SUCCESS;
}

// Takes an array of channels, channel_list, of type select_t and the array length, channel_count, as inputs
// This API iterates over the provided list and finds the set of possible channels which can be used to invoke the required operation (send or receive) specified in select_t
// If multiple options are available, it selects the first option and performs its corresponding action
// If no channel is available, the call is blocked and waits till it finds a channel which supports its required operation
// Once an operation has been successfully performed, select should set selected_index to the index of the channel that performed the operation and then return SUCCESS
// In the event that a channel is closed or encounters any error, the error should be propagated and returned through select
// Additionally, selected_index is set to the index of the channel that generated the error
enum chan_status channel_select(size_t channel_count, select_t* channel_list, size_t* selected_index)
{
    /* IMPLEMENT THIS */
    // Create a local semaphore that channels will post to when they become ready
    // Initialized to 0 so sem_wait will block immediately if called
    sem_t sem;
    sem_init(&sem, 0, 0);

    // Register our semaphore with every channel in the list so that send/receive/close operations on those channels will wake us up
    // Skip duplicate channels to avoid posting to our semaphore multiple times for the same channel event
    for (size_t i = 0; i < channel_count; i++) {
	bool already_registered = false;
	for (size_t j = 0; j < i; j++) {
	    if (channel_list[j].channel == channel_list[i].channel) {
	    	already_registered = true;
		break;
	    }
	}
	if (!already_registered) {
    	    pthread_mutex_lock(&channel_list[i].channel->lock);
	    list_insert(channel_list[i].channel->select_sems, &sem);
	    pthread_mutex_unlock(&channel_list[i].channel->lock);
	}
    }

    // Attempt one nonblocking pass over all channels
    enum chan_status result = OTHER_ERROR;
    while ((result = try_select(channel_count, channel_list, selected_index)) == WOULDBLOCK) {
    	sem_wait(&sem);
    }

    // Unregister our semaphore from every channel's select_sems list so we no longer receive notifications from these channels
    // Skip duplicate channels since we only registered once per unique channel
    for (size_t i = 0; i < channel_count; i++) {
	bool already_unregistered = false;
	for (size_t j = 0; j < i; j++) {
	    if (channel_list[j].channel == channel_list[i].channel) {
	    	already_unregistered = true;
		break;
	    }
	}
	if (!already_unregistered) {
    	    pthread_mutex_lock(&channel_list[i].channel->lock);
	    list_node_t* node = list_find(channel_list[i].channel->select_sems, &sem);
	    if (node != NULL) {
	        list_remove(channel_list[i].channel->select_sems, node);
	    }
	    pthread_mutex_unlock(&channel_list[i].channel->lock);
	}
    }
    sem_destroy(&sem);
    return result;
}
