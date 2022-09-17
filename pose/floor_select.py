import time

from api import from2
""" Floor selection based on poses up and squat """


class FloorSelect:

    def __init__(self,floor = 0):
        self.origin_floor = floor
        self.floor_ = floor
        self.spacing = 0.15
        self.lockin = time.time()+1000
           
    def use_position(self, pred):
        if pred=='arm_up' or pred=='double_up':
            self.floor_ += self.spacing
            self.lockin = time.time()
        elif pred=='squat':
            self.floor_ -= self.spacing
            self.lockin = time.time()
        else:
            if time.time()<self.lockin:
                pass
            elif time.time()-self.lockin<2:
                self.lockin = time.time()+1000
                print("api")
                from2(self.origin_floor, self.floor)
                self.origin_floor = self.floor

    @property 
    def floor(self):
        print(self.floor_)
        return int(self.floor_)

