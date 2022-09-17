import json
import numpy as np

from sklearn.ensemble import RandomForestRegressor, RandomForestClassifier
from sklearn.model_selection import cross_validate


# also think about mirroring

positions = ['arm_up', 'double_up', 'squat', 'stand']
pos = {v:idx for idx,v in enumerate(positions)}

def process_x(x):
    # center on nose
    keypoints = np.array(x)
    keypoints = keypoints[1:]-keypoints[0]
    return keypoints.reshape(-1)

def process_y(y):
    y_cat = np.zeros(len(positions))
    y_cat[pos[y]] = 1
    return pos[y]

class PosePredictor:

    def __init__(self):

        j = json.load(open('dataset2.json'))
        # j += json.load(open('dataset1.json'))
        print('Train Samples', len(j))

        X = [process_x(X) for X, _ in j]
        y = [process_y(y) for _, y in j]

        #reg = RandomForestClassifier(n_estimators=500)
        #cv_results = cross_validate(reg, X, y, cv=5)
        #print('cv_results', cv_results)

        reg = RandomForestClassifier(n_estimators=500)
        reg.fit(X, y)

        self.reg = reg 
    
    def single_pred(self,X):
        X = process_x(X)
        y = self.reg.predict(X.reshape(1,-1))[0]
        return positions[y]

# PosePredictor()