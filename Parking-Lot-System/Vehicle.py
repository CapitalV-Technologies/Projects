import time

class Vehicle:

    def __init__ (self, spot):
        self.start_time = time.perf_counter()
        spot_taken = spot
    
    def exits(self):
        return float(round(time.perf_counter() - self.start_time, 2))