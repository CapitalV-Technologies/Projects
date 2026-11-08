import time
from Vehicle import Vehicle
import uuid


class ParkingGarage:

    def __init__(self):
        self.small = 2
        self.medium = 2
        self.large = 2
        self.total_spots = 6
        # Pricing is price/hour
        self.__bike_price = 1
        self.__car_price = 2
        self.__truck_price = 3
        self.profit = 0
        self.vehicles = {}
    
    def price(self):
        print(f"The Bike price is ${self.__bike_price}. The Car price is ${self.__car_price}. The Truck price is ${self.__truck_price}.")
    
    def get_profit(self):
        return self.profit

    def get_bike_price(self):
        return self.__bike_price
    
    def get_car_price(self):
        return self.__car_price
    
    def get_truck_price(self):
        return self.__truck_price

    def set_bike_price(self, password, new_bike_price):
        # Simple Password Check to show thinking about security
        if password == "1234":
            self.__bike_price = new_bike_price
            print(f"New Bike Price has been set. The new price is now ${self.__bike_price}")
        else:
            print("Password is incorrect. Bike Price not updated.")

    def set_car_price(self, password, new_car_price):
        if password == "1234":
            self.__car_price = new_car_price
            print(f"New Car Price has been set. The new price is now ${self.__car_price}")
        else:
            print("Password is incorrect. Car Price not updated.")
    
    def set_truck_price(self, password, new_truck_price):
        if password == "1234":
            self.__truck_price = new_truck_price
            print(f"New Truck Price has been set. The new price is now ${self.__truck_price}")
        else:
            print("Password is incorrect. Truck Price not updated.")

    def enters(self, vehicle_type):

        # Check if spots available
        spot = ""
        if vehicle_type == "bike":
            spot = "small"
        elif vehicle_type == "car":
            spot = "medium"
        elif vehicle_type == "truck":
            spot = "large"
        
        ticket_number = str(uuid.uuid4())
        vehicle_object = self.enters_helper(vehicle_type, spot)
        if vehicle_object == -1:
            return
        
        self.vehicles[ticket_number] = vehicle_object

        return f"Your parking ticket is {ticket_number}. Please save this for when you exit."

    def enters_helper(self, vehicle_type, spot):
        if getattr(self, spot) < 1:
            print("All spots taken for your vehicle are taken. Please come back later")
            return -1
        setattr(self, spot, getattr(self, spot) - 1)
        self.total_spots -= 1
        vehicle_object = Vehicle(vehicle_type, spot)
        return vehicle_object
    
    def exits(self, ticket_number):
        if ticket_number == "lost":
            return "Please call handle_lost_ticket function with your vehicle type as parameter"

        if ticket_number not in self.vehicles:
            return "This ticket number was not found. Please try again."
        vehicle_object = self.vehicles[ticket_number]
        del self.vehicles[ticket_number]
        spot = vehicle_object.spot
        vehicle_type = vehicle_object.vehicle_type

        if spot == "small":
            self.small += 1
        elif spot == "medium":
            self.medium += 1
        elif spot == "large":
            self.large += 1
        
        if vehicle_type == "bike":
            price = self.get_bike_price()
        elif vehicle_type == "car":
            price = self.get_car_price()
        elif vehicle_type == "truck":
            price = self.get_truck_price()

        parked_time = vehicle_object.exits()
        payment_due = float(price) * parked_time

        self.profit += payment_due

        return f"You have parked for {parked_time} hours at a price of ${price}/hour. You now owe ${payment_due}."

    def handle_lost_ticket(self, vehicle):
        # Problem: Our vehicle object gets lost in our dictionary here. 
        if vehicle == "bike":
            self.small += 1
        elif vehicle == "car":
            self.medium += 1
        elif vehicle == "truck":
            self.large += 1
        price = 100
        self.profit += 100
        return "You now owe $100 for losing your ticket. You may exit the garage."

    def add_small_spots(self, password, spots):
        if password != "1234":
            return "Password is incorrect. Spots not updated"
        self.small += spots
        self.total_spots += spots
        return f"Added {spots} small spots"

    def add_medium_spots(self, password, spots):
        if password != "1234":
            return "Password is incorrect. Spots not updated"
        self.medium += spots
        self.total_spots += spots
        return f"Added {spots} medium spots"

    def add_large_spots(self, password, spots):
        if password != "1234":
            return "Password is incorrect. Spots not updated"
        self.large += spots
        self.total_spots += spots
        return f"Added {spots} large spots"

    def status(self):
        return f"There are {self.small} small spots available, {self.medium} medium spots available, and {self.large} large spots available"

