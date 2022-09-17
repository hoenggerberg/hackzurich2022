import cv2
import tensorflow_hub as hub

def get_capture():
    # Loads video source (0 is for main webcam)
    cap = cv2.VideoCapture(0)

    # Checks errors while opening the Video Capture
    if not cap.isOpened():
        print('Error loading video')
        quit()

    success, img = cap.read()
        
    if not success:
        print('Error reding frame')
        quit()

    return cap

def get_model():
    # Download the model from TF Hub.
    model = hub.load('https://tfhub.dev/google/movenet/singlepose/thunder/3')
    movenet = model.signatures['serving_default']

    return movenet