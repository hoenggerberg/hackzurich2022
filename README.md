# YMCA HackZurich Submission

[Elevator Screen Webapp - click me](https://hoenggerberg.github.io/)

[Android APK](https://drive.google.com/file/d/1iamX1tHXR-soC0SzUgj4FXB35zNVcms2/view?usp=sharing)

[Video](https://youtu.be/UN25-8ofQlU)

With our mobile app (Flutter), you can choose from activities like Dancing, Stretching, Karaoke  Trivia, and many others.
You tell us what you like so we can provide the perfect experience for you with our in-elevator screen and sound system. 
Not gamified enough for you? Our pose prediction allows you to pick a floor without touching any buttons. To go up, simply reach out with your arms, or squat, to go down.

Riding with others? Your interests get matched so that you can all enjoy the ride. You can even interact with riders in other elevators.
Our backend combined with the Schindler API  makes all of this work seamlessly.

All on board (chuchu), we’re ready to elevate your day!

## Flutter mobile app

In `app/`

![Mobile App to set preferences](images/app.jpeg)

Our Flutter app for mobile and web allows us to match different elevator riders with each other to play minigames or perform solo. 

## Flutter screen app

In `screen/`

![Elevator Screen](images/screen.png)

Flutter app that is run on screens in the elevator.

In the screen subfolder you can find webpage gui for elevator screens

## Pose Estimator

![Pose Code](images/pose.png)

In `pose/`

One of our coolest features is our Pose Prediction. Based on skeleton keypoints we can predict human poses like iconic dances and positions from pop culture. Not amazed enough? All of this works on device and in realtime. Wow. Still not? We are able to predict poses corretly with `95% accuracy on validation` sets. You want to test it. Sure. Just keep reading or ask us for a demo. 

We repeat: `On device, realtime and 95% accurate`

ah and of course you can even add your own poses and control some elevators... Touch free. Why has this not been araund for Covid.

### Install 
``` pip install -r requirements.txt ```

### Run detectiion

``` python3 main.py ```

This will open a window with the webcam feed predicting and showing keypoints. To get started with pose predictions please `press P`. This might take a minute until the model is loaded. 

### Pose Elevator controll

By `pressing P folowed by F` you reach the elevator controll panel. You might notice the floor indicator on the lower left of your screen. You can increase the selected floor by stretching your arms (one or two arms are fine). Similarly decreasing the floor level is accomplished by squatting. After standing still for 1-2 seconds the selected floor is choosen. You can view the commanded elevator in the [Schindler Virtual Elevator Website](https://hack1.myport.guide/ui/paas/lift) (elevator D). 


### Adding new poses

Adding new poses is simple and very straight forward. Just run ```python main.py --sample [poses]``` to sample new or existing poses. You will get 5 seconds to prepare for each pose and 10 seconds where sampling happens. Please add many variations of the same pose to help training. To retrain all, including new poses `press P`. 

So: How cool is that.

## Backend

in `backend/`

![Backend](images/backend.png)

