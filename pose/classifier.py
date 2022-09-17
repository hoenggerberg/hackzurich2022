import os
import json
import numpy as np

from pathlib import Path
from sklearn.utils import shuffle
from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
from sklearn.model_selection import cross_validate


# also think about mirroring

def process_x(x):
    # center on nose
    keypoints = np.array(x)
    keypoints = keypoints[1:] - keypoints[0]
    return keypoints.reshape(-1)

class PosePredictor:
    def __init__(self):
        tmp = [
            Path(root, f)
            for root, _, files in os.walk("./")
            for f in files
            if "_" in f and f.startswith("dataset") and f.endswith(".json")
        ]
        print(tmp)

        def load_dataset(path):
            with open(path, "r") as f:
                return json.load(f)
            

        X = []
        y = []
        self.labels = []
        for i,p in enumerate(tmp):
            label =  p.name.split(".")[0].split("_")[1]
            self.labels.append(label)

            tmp_data = load_dataset(p)
            for x in tmp_data:
                X.append(process_x(x))
                y_cat = np.zeros(len(tmp))
                y_cat[i] = 1
                y.append(y_cat)
        X,y = shuffle(X,y)
        reg = RandomForestClassifier(n_estimators=300)
        cv_results = cross_validate(reg, X, y, cv=5)
        print('cv_results', cv_results)

        reg = RandomForestClassifier(n_estimators=300)
        reg.fit(X, y)

        self.reg = reg

    def single_pred(self, X):
        X = process_x(X)
        y = np.argmax(self.reg.predict(X.reshape(1, -1))[0])
        return self.labels[y]