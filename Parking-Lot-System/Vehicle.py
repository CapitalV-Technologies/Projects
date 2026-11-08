import time

class Vehicle:

    def __init__ (self, vehicle_type, spot):
        self.start_time = time.perf_counter()
        self.spot = spot
        self.vehicle_type = vehicle_type
    
    def exits(self):
        seconds_parked = float(round(time.perf_counter() - self.start_time, 2))
        minutes_parked = round(seconds_parked / 60.0, 2)
        hours_parked = round(minutes_parked / 60.0, 2)
        return hours_parked