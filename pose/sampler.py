import time
import json
from collections import defaultdict
from pathlib import Path

class Sampler:

    def __init__(self):
        self.start = self.time
        self.pause_time = 5
        self.capture_time = 10

        self.samples = defaultdict(list)

    @property
    def time(self):
        return int(time.time())

    def record(self, keypoints, pose: str) -> tuple[bool, str]:
        delta = self.time - self.start

        data_path = Path('dataset_{pose}.json')
        if data_path.exists():
            with open(data_path, "r") as f:
                self.samples[pose] = json.load(f)

        if delta < self.pause_time:
            # prepare
            self.current_pose = pose

            return False, f"{self.current_pose} in {self.pause_time-delta}"
        elif delta < self.pause_time + self.capture_time:
            # stay -> pause in
            self.samples[self.current_pose].append(keypoints.tolist())
            return False, f"pause in {self.pause_time+self.capture_time - delta}"
        self.save()
        return True, f"Done with {pose}"
        
    def save(self):
        for k,v in self.samples.items():
            json.dump(v,open(f'dataset_{k}.json','w'))


    

