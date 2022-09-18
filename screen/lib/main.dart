import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:screen/models/ElevatorState.dart';
import 'package:screen/models/trivia.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  ElevatorState latestState = ElevatorState(id: "init");
  String text = "Welcome";
  Widget textW = Text("");
  bool textVisible = true;

  int triviaIdx = 0;

  String mode = "default";

  Color color1 = Colors.purple;
  Color color2 = Colors.purpleAccent;

  double radAdd = 100;
  double radMult = 0.5;

  String curId = "OFFLINE ";

  Timer? timer;

  void changeText(String text) {
    setState(() {
      this.text = text;
      textW = Text(
        text,
        style: TextStyle(fontSize: 40),
      );
    });
  }

  late AnimationController _animationController;
  late Animation _animation;

  final player = AudioPlayer();

  void updateState() async {
    ElevatorState e = await fetchElevatorState("HARDCODE");

    String idNew = e.id;
    if (latestState.id != idNew) {
      print("update");
    }

    setState(() {
      latestState = e;
      mode = latestState.activity;
      curId = e.timestamp.toString();
    });
  }

  void periodicUpdate() {
    timer = timer ??
        Timer.periodic(Duration(seconds: 1), (timer) {
          updateState();
        });
  }

  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 1), (Timer t) => updateState());
    periodicUpdate();

    showStuff();

    super.initState();
  }

  void showStuff() {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    //_animationController.repeat(reverse: true);
    bool reverse = true;
    _animationController.forward();
    _animation = Tween(begin: 2.0, end: 40.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {

        switch(mode) {
          case "Breathing Exercise": {

            setState(() {
              color1 = Colors.white;
              color2 = Colors.blueAccent;

              radAdd = 40;
              radMult = 2;
              _animationController.duration=Duration(milliseconds: 4000);
            });


            if (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) {
              //_animationController.reverse();
              changeText("");
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (reverse) {
                  _animationController.reverse();
                  playAudio('assets/breath_out.mp3');
                  changeText("breathe out");
                } else {
                  _animationController.forward();
                  playAudio('assets/breath_in.mp3');
                  changeText("breathe in");
                }
                reverse = !reverse;
              });
            }

          } break;

          case "Squat": {

            setState(() {
              color1 = Colors.red;
              color2 = Colors.redAccent;

              radAdd = 90;
              radMult = 1;
              _animationController.duration=Duration(milliseconds: 1000);
            });

            if (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) {
              //_animationController.reverse();
              changeText("Squat");
              Future.delayed(const Duration(milliseconds: 1), () {
                if (reverse) {
                  _animationController.reverse();
                  changeText("");
                } else {
                  _animationController.forward();
                  changeText("Squat");
                }
                reverse = !reverse;
              });
            }


          } break;

          case "Trivia": {

            setState(() {
              color1 = Colors.yellow;
              color2 = Colors.yellowAccent;

              radAdd = 50;
              radMult = 1;
              _animationController.duration=Duration(milliseconds: 6000);
            });


            if (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) {
              //_animationController.reverse();
              changeText("");
              Future.delayed(const Duration(milliseconds: 1000), () {
                if (reverse) {
                  _animationController.reverse();
                  changeText(Trivia.qa[triviaIdx++ % Trivia.qa.length]);
                } else {
                  _animationController.forward();
                  changeText(Trivia.qa[triviaIdx++ % Trivia.qa.length]);
                }
                reverse = !reverse;
              });
            }

          } break;

          default: {

            setState(() {
              color1 = Colors.purple;
              color2 = Colors.purpleAccent;

              radAdd = 90;
              radMult = 0.2;
              _animationController.duration=Duration(milliseconds: 1000);
            });

            if (status == AnimationStatus.completed ||
                status == AnimationStatus.dismissed) {
              //_animationController.reverse();
              changeText("Welcome");
              Future.delayed(const Duration(milliseconds: 1), () {
                if (reverse) {
                  _animationController.reverse();
                } else {
                  _animationController.forward();
                }
                reverse = !reverse;
              });
            }



        } break;




        }


      });
  }

  Future<void> playAudio(String file) async {
    await player.play(DeviceFileSource(file)); // will immediately start playing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(seconds: 1),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 40),
                    key: ValueKey<String>(text),
                  ),
                ),
                SizedBox(
                  height: 150,
                ),
                Container(
                  width: _animation.value * radMult + radAdd,
                  height: _animation.value * radMult + radAdd,
                  //child: Icon(Icons.mic,color: Colors.white,),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color1, //Color.fromARGB(255, 27, 28, 30),
                      boxShadow: [
                        BoxShadow(
                            color: color2,
                            //Color.fromARGB(130, 237, 125, 80),
                            blurRadius: _animation.value * radMult,
                            spreadRadius: _animation.value * radMult)
                      ]),
                ),
              ],
            ),
          ),
          Row(
            children: [
              InkWell(
                child: Text(curId),
                onTap: () {
                  updateState();
                },
              ),
              InkWell(
                child: Text("default "),
                onTap: () {
                  setState(() {
                    mode = "default ";
                  });
                  ElevatorState(id: "HARDCODE", floor: 0, activity: "default", timestamp: 0.0).update();
                  ;
                },
              ),
              InkWell(
                child: Text("breathe "),
                onTap: () {
                  setState(() {
                    mode = "Breathing Exercise";
                  });
                  ElevatorState(id: "HARDCODE", floor: 0, activity: "Breathing Exercise", timestamp: 0.0).update();
                  ;
                },
              ),
              InkWell(
                child: Text("squat "),
                onTap: () {
                  setState(() {
                    mode = "Squat";
                  });
                  ElevatorState(id: "HARDCODE", floor: 0, activity: "Squat", timestamp: 0.0).update();
                  ;
                },
              ),
              InkWell(
                child: Text("trivia "),
                onTap: () {
                  setState(() {
                    mode = "Trivia";
                  });
                  ElevatorState(id: "HARDCODE", floor: 0, activity: "Trivia", timestamp: 0.0).update();
                  ;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
