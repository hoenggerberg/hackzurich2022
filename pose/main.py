import cv2
import tensorflow as tf
import numpy as np

import argparse
import movenet

from draw import Canvas
from text import writeText
from util import get_capture, get_model
from sampler import Sampler
from classifier import PosePredictor
from floor_select import FloorSelect

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--sample", type=str, nargs="+")

    classifier = None
    sampler = None
    floor_select = None
    args = parser.parse_args()

    cap = get_capture()
    model_movenet = get_model()
    success, img = cap.read()

    y, x, _ = img.shape

    canvas = Canvas(x,y)
    while success:
        keypoints = movenet.run_inference(model_movenet, img) 
        #remove background
        #img = np.full_like(img,0)

        canvas.draw_keypoints(keypoints, img)
        canvas.draw_pose(keypoints, img)
        if args.sample:
            if not sampler:
                sampler = Sampler()
            done, msg = sampler.record(keypoints, args.sample[0])
            if done:
                args.sample = args.sample[1:]
                sampler = None
            writeText(img,msg)
        if classifier is not None:
            pred_pos = classifier.single_pred(keypoints)
            writeText(img,pred_pos,low=False)
        if floor_select is not None:
            floor_select.use_position(pred_pos)
            floor = floor_select.floor
            writeText(img,f'{floor}')
        # scale 
        img = cv2.resize(img, dsize=(x*2, y*2), interpolation=cv2.INTER_CUBIC)

        # Shows image
        cv2.imshow('Movenet', img)
        # Waits for the next frame, checks if q was pressed to quit
        if (key:=cv2.waitKey(1)) == ord("q"):
            break
        elif key == ord("s"):
            sampler = Sampler()
        elif key == ord("p"):
            classifier = PosePredictor()
        elif key == ord("f"):
            floor_select = FloorSelect()
            
        # Reads next frame
        success, img = cap.read()
    
    cap.release()