import 'package:app/models/activity.dart';
import 'package:flutter/material.dart';

class ActivitiesData {
  static List<Activity> activities = [
    Activity("Breathing Exercise", Icons.air, Colors.lightBlue),
    Activity("Stretching", Icons.accessibility_new, Colors.lightGreen),
    Activity("Karaoke", Icons.mic_external_on_outlined, Colors.purple),
    Activity("Dance", Icons.emoji_people, Colors.pinkAccent),
    Activity("Squats", Icons.fitness_center, Colors.red),
  ];
}