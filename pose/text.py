import cv2

def writeText(img, text='squat', low = True):
    # font
    font = cv2.FONT_HERSHEY_SIMPLEX
    
    # fontScale
    fontScale = 2
    
    #origin
    if low:
        org = (50, 400)
    else:
        org = (50,50)
        
    # Blue color in BGR
    color = (255, 0, 0)
    
    # Line thickness of 2 px
    thickness = 5
    
    # Using cv2.putText() method
    cv2.putText(img, text, org, font, 
                    fontScale, color, thickness, cv2.LINE_AA)