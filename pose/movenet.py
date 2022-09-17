# Import TF and TF Hub libraries.
import cv2
import tensorflow as tf
import numpy as np

from draw import Canvas
from text import writeText
from util import get_capture, get_model
from sampler import Sampler
from classifier import PosePredictor
from floor_select import FloorSelect

cap = get_capture()
movenet = get_model()
classifier = None
sampler = None
floor_select = None
success, img = cap.read()

y, x, _ = img.shape

canvas = Canvas(x,y)

while success:
    # A frame of video or an image, represented as an int32 tensor of shape: 256x256x3. Channels order: RGB with values in [0, 255].
    tf_img = cv2.resize(img, (256,256))
    tf_img = cv2.cvtColor(tf_img, cv2.COLOR_BGR2RGB)
    tf_img = np.asarray(tf_img)
    tf_img = np.expand_dims(tf_img,axis=0)

    # Resize and pad the image to keep the aspect ratio and fit the expected size.
    image = tf.cast(tf_img, dtype=tf.int32)

    # Run model inference.
    outputs = movenet(image)
    # Output is a [1, 1, 17, 3] tensor.
    keypoints = outputs['output_0']
    # Converts to numpy array
    keypoints = keypoints[0,0,:,:].numpy()
    
    #remove background
    #img = np.full_like(img,0)

    canvas.draw_keypoints(keypoints, img)
    canvas.draw_pose(keypoints, img)
    if sampler is not None:
        writeText(img,sampler.record(keypoints))
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

if sampler is not None:
    sampler.save()
