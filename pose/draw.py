import cv2


class Canvas:

    def __init__(self, x, y, threshold=0.05):
        self.x = x
        self.y = y
        self.threshold = threshold

    def keypoint2coord(self, keypoint):
        yc = int(keypoint[0] * self.y)
        xc = int(keypoint[1] * self.x)
        return (xc, yc)

    def draw_line(self, keypoint0, keypoint1, img):
        if keypoint0[2] > self.threshold and keypoint1[2] > self.threshold:
            xy0, xy1 = self.keypoint2coord(
                keypoint0), self.keypoint2coord(keypoint1)
            cv2.line(img, xy0, xy1, (255, 0, 0), 5)

    def draw_keypoints(self, keypoints, img):
        for k in keypoints:
            # Checks confidence for keypoint
            if k[2] > self.threshold:
                # Draws a circle on the image for each keypoint
                img = cv2.circle(img, self.keypoint2coord(k),
                                 2, (0, 255, 0), 5)

    def draw_pose(self, k, img):
        # pose skeleton
        nose = k[0]
        left_eye = k[1]
        right_eye = k[2]
        left_ear = k[3]
        right_ear = k[4]
        left_shoulder = k[5]
        right_shoulder = k[6]
        left_elbow = k[7]
        right_elbow = k[8]
        left_wrist = k[9]
        right_wrist = k[10]
        left_hip = k[11]
        right_hip = k[12]
        left_knee = k[13]
        right_knee = k[14]
        left_ankle = k[15]
        right_knee = k[16]

        # upper
        self.draw_line(left_wrist, left_elbow, img)
        self.draw_line(left_elbow, left_shoulder, img)
        self.draw_line(left_shoulder, right_shoulder, img)
        self.draw_line(right_shoulder, right_elbow, img)
        self.draw_line(right_elbow, right_wrist, img)

        # lower
        self.draw_line(left_knee, left_hip, img)
        self.draw_line(left_ankle, left_knee, img)
        self.draw_line(left_hip, right_hip, img)
        self.draw_line(right_hip, right_knee, img)
        self.draw_line(right_knee, right_knee, img)
