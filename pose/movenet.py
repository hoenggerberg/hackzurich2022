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


def run_inference(model, img) -> np.ndarray:
    # A frame of video or an image, represented as an int32 tensor of shape: 256x256x3. Channels order: RGB with values in [0, 255].
    tf_img = cv2.resize(img, (256,256))
    tf_img = cv2.cvtColor(tf_img, cv2.COLOR_BGR2RGB)
    tf_img = np.asarray(tf_img)
    tf_img = np.expand_dims(tf_img,axis=0)

    # Resize and pad the image to keep the aspect ratio and fit the expected size.
    image = tf.cast(tf_img, dtype=tf.int32)

    # Run model inference.
    outputs = model(image)
    # Output is a [1, 1, 17, 3] tensor.
    keypoints = outputs['output_0']
    # Converts to numpy array
    return keypoints[0,0,:,:].numpy()
