import 'package:app/data/activities_data.dart';
import 'package:app/models/activity.dart';
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
      title: 'Elevate My Day',
      theme: ThemeData(
        primarySwatch: Colors.purple,
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

  List<bool> acitivity_active = List.generate(ActivitiesData.activities.length, (index) => false);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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
                        acitivity_active[index] = !acitivity_active[index];
                      });
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(a.icon, color: acitivity_active[index] ? a.color : null),
                        Text(
                          a.name,
                          style: TextStyle(
                              color:
                              acitivity_active[index] ? Colors.black : Theme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
