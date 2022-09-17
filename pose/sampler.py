import time
import json

class Sampler:

    def __init__(self):
        self.start = self.time
        self.delta = 5
        self.pos = ['arm_up', 'double_up', 'squat', 'stand']
        self.samples = []

    @property
    def time(self):
        return int(time.time())

    def record(self, keypoints):
        pos = ((self.time - self.start) // (2*self.delta)) % len(self.pos)
        delta = (self.time - self.start) % (2*self.delta)

        if delta < self.delta:
            # prepare
            self.current_pose = self.pos[pos]

            return f"{self.current_pose} in {self.delta-delta}"
        else:
            # stay -> pause in
            self.samples.append([keypoints.tolist(),self.current_pose])
            return f"pause in {2*self.delta - delta}"

    def save(self):
        json.dump(self.samples,open('dataset.json','w'))

    

