Language Used:  

Python  

Step-by-step how to run:  
    git clone https://github.com/CapitalV-Technologies/Projects.git  
    cd Projects  
    cd Parking-Lot-System  
    python3 -i Parking_Garage.py -v  

    User Actions:
    x = ParkingGargage()
    x.price()
    x.status()
    x.enters(vehicle) - ("bike", "car", "truck")
    x.exits(ticket_number) - (use "lost" for lost ticket)

    Owner Actions:
    x.add_small_spots(password, spots_to_add)
    x.add_medium_spots(password, spots_to_add)
    x.add_large_spots(password, spots_to_add)
    x.set_bike_price(password, new_price)
    x.set_car_price(password, new_price)
    x.set_truck_price(password, new_price)

Design choices:  
    1. I wanted to mimick an actual parking garage as best as possible  
    2. I wanted it to be as simple as possible for the user(any complexity behind the scenes)  
    3. I wanted reusable code which is why I created a Vehicle class instead of seperate Car, Bike, and Truck classes  
    4. I wanted people to pay by the second they are in the parking garage, not rounded up.   

Possible Extensions:  
    1. Handling a lost ticket. Right now, there is no way to remove the Vehicle object within the dictionary when a user loses their ticket. You could add the ticket_number to the Vehicle Object, sweep the dictionary, find the correct object, and then remove it.  
    2. Allowing smaller vehicles to park in a larger spot size if their own spot size is filled.   
    3. Decrease profit when adding spots to parking garage  