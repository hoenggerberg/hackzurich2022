import 'package:flutter/material.dart';

class Mode {
  final String name;
  final Color color1;
  final Color color2;

  Mode(this.name, this.color1, this.color2);
}

class ModesData {
  static List<Mode> modes = [
      Mode("default", Colors.purple, Colors.purpleAccent),
      Mode("Breathing Exercise", Colors.white, Colors.blueAccent),
      Mode("Fun Facts", Colors.yellow, Colors.yellowAccent),
      Mode("Breathing Exercise", Colors.white, Colors.blueAccent),
    ];
}