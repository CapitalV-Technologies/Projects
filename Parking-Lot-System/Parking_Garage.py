import time
from Vehicle import Vehicle
import uuid


class ParkingGarage:

    def __init__(self):
        self.small = 2
        self.medium = 2
        self.large = 2
        self.total_spots = 6
        self.__bike_price = 1
        self.__car_price = 2
        self.__truck_price = 3
        self.total_profit = 0
        self.vehicles = {}
    
    def get_price(self):
        print(f"The Bike price is ${self.__bike_price}. The Car price is ${self.__car_price}. The Truck price is ${self.__truck_price}.")

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
            print("Password is incorrect. Bike Price not updated. ")

    def set_car_price(self, password, new_car_price):
        if password == "1234":
            self.__car_price = new_car_price
            print(f"New Car Price has been set. The new price is now ${self.__car_price}")
        else:
            print("Password is incorrect. Car Price not updated. ")
    
    def set_truck_price(self, password, new_truck_price):
        if password == "1234":
            self.__truck_price = new_truck_price
            print(f"New Truck Price has been set. The new price is now ${self.__truck_price}")
        else:
            print("Password is incorrect. Truck Price not updated. ")

    def enters(self, vehicle_type):

        # Check if spots available
        spot = ""
        if vehicle_type == "bike":
            spot = "small"
        elif vehicle_type == "car":
            spot = "medium"
        elif vehicle_type == "truck":
            spot = "large"
        
        ticket_number = uuid.uuid4()
        self.vehicles[ticket_number] = self.enters_helper(spot)

        return f"Your parking ticket is {ticket_number}. Please save this for when you exit."

    def enters_helper(self, spot):
        if getattr(self, spot) < 1:
            return "All spots taken for your vehicle are taken. Please come back later"
        setattr(self, spot, getattr(self, spot) - 1)
        self.total_spots -= 1
        vehicle_object = Vehicle(spot)
        return vehicle_object