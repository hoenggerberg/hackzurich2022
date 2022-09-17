import 'package:app/models/activity.dart';
import 'package:flutter/material.dart';

class ActivitiesData {
  static List<Activity> activities = [
    Activity("Breathing Exercise", Icons.air, Colors.lightBlue),
    Activity("Stretching", Icons.accessibility_new, Colors.lightGreen),
    Activity("Karaoke", Icons.mic_external_on_outlined, Colors.greenAccent),
    Activity("Dance", Icons.emoji_people, Colors.pinkAccent),
    Activity("Squats", Icons.fitness_center, Colors.red),
    Activity("News", Icons.newspaper, Colors.indigoAccent),
    Activity("Fun Facts", Icons.lightbulb, Colors.yellow),
    Activity("Motivational Speech", Icons.record_voice_over, Colors.teal),
    Activity("Joke", Icons.sentiment_very_satisfied_outlined, Colors.orange),
  ];
}