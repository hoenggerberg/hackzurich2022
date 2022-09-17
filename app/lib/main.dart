import 'package:app/data/activities_data.dart';
import 'package:app/models/activity.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:app/models/ElevatorState.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Elevate My Day',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        highlightColor: Colors.red
      ),
      home: const MyHomePage(title: 'Elevate My Day'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String last_activity = "default";
  int floor = 0;
  bool active = false;
  List<bool> acitivity_active = List.generate(ActivitiesData.activities.length, (index) => false);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar:  NewGradientAppBar(
          title: Text("Elevate my day"),
          gradient: LinearGradient(colors: [Colors.purple, Colors.red])
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10,),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AvatarGlow(
                  glowColor: active ? Colors.green : Theme.of(context).primaryColor,
                  endRadius: 70.0,
                  duration: Duration(milliseconds: 2000),
                  repeat: true,
                  showTwoGlows: true,
                  child: IconButton(
                    icon: Icon(Icons.power_settings_new),
                    isSelected: active,
                    color: active ? Colors.green : Colors.grey,
                    iconSize: 100,
                    onPressed: () {
                      setState(() {
                        active = !active;
                      });
                      ElevatorState(id: "HARDCODE", floor: 0, activity: "default", timestamp: 0.0).update();
                    },
                  ),
                ),
                Text(active ? "Elevator activities\nare enabled" : "Elevator activities\nare disabled",)
              ],
            ),
            SizedBox(height: 50,),
            Wrap(
              children: List.generate(ActivitiesData.activities.length, (index) {
                Activity a = ActivitiesData.activities[index];
                return Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      side: BorderSide(width: 1, color: Theme.of(context).primaryColor),
                      backgroundColor: acitivity_active[index] ? Theme.of(context).primaryColor : null,
                    ),
                    onPressed: () {
                      setState(() {
                        if (!acitivity_active[index]) {
                          last_activity = ActivitiesData.activities[index].name;
                        }
                        acitivity_active[index] = !acitivity_active[index];
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(a.icon, color: acitivity_active[index] ? a.color : null),
                        SizedBox(width: 5,),
                        Text(
                          a.name,
                          style: TextStyle(
                              color:
                              acitivity_active[index] ? Colors.white : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
            Spacer(),
            Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                  borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          border: Border.all(color: Theme.of(context).primaryColor, width: 4),
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: Center(child: Icon(Icons.unfold_more, size: 60,),),
                      ),
                      onTap: () {
                        ElevatorState(id: "HARDCODE", floor: floor, activity: last_activity, timestamp: 0.0).update();
                      },
                    ),
                    SizedBox(width: 80,),
                    Container(
                      width: 40,
                      height: 100,
                      child: ListView.builder(
                        itemCount: 35,
                        itemBuilder: (context, index) {
                          return VisibilityDetector(
                              key: Key(index.toString()),
                              onVisibilityChanged: (VisibilityInfo info) {
                                if (info.visibleFraction == 1)
                                  setState(() {
                                    floor = index;
                                    print(floor);
                                  });
                              },
                              child: Text(index.toString(), style: TextStyle(fontSize: 25, color: index==floor? Theme.of(context).highlightColor : null),)
                          );
                        },
                      ),
                      // child: ListView(
                      //   children: List.generate(37, (index) {
                      //     return Text(index.toString(), style: TextStyle(fontSize: 20, color: index==floor? Theme.of(context).highlightColor : null),);
                      //   }),
                      // ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
