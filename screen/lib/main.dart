import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
  String text = "Welcome";
  Widget textW = Text("");
  bool textVisible = true;

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

  @override
  void initState() {
    // TODO: implement initState
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 4),
    );
    //_animationController.repeat(reverse: true);
    bool reverse = true;
    _animationController.forward();
    playAudio('assets/breath_in.mp3');
    changeText("breath in");
    _animation = Tween(begin: 2.0, end: 40.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
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
      });
    super.initState();
  }

  Future<void> playAudio(String file) async {
    await player.play(DeviceFileSource(file)); // will immediately start playing
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      // ),
      // body: Stack(
      //   children: [
      //     Container(
      //       width: 60,
      //       height: 60,
      //       decoration: BoxDecoration(
      //           shape: BoxShape.circle,
      //           gradient: LinearGradient(colors: [
      //             Colors.orange,
      //             Theme.of(context).primaryColor
      //           ])),
      //       // child: Transform.rotate(
      //       //   angle: true ? 0 : 3.1415926 / 4.0,
      //       //   child: Icon(Icons.add),
      //       // ),
      //     )
      //   ],
      // ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(seconds: 1),
              transitionBuilder: (Widget child, Animation<double> animation) {
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
              width: _animation.value * 2 + 30,
              height: _animation.value * 2 + 30,
              //child: Icon(Icons.mic,color: Colors.white,),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white, //Color.fromARGB(255, 27, 28, 30),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.blueAccent,
                        //Color.fromARGB(130, 237, 125, 80),
                        blurRadius: _animation.value,
                        spreadRadius: _animation.value)
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}