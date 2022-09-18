import 'dart:convert';

import 'package:http/http.dart' as http;

class ElevatorState {
  final String id;
  int floor;
  String activity;
  double timestamp;

  ElevatorState({ required this.id,
    this.floor = 0, this.activity = "", this.timestamp=0.0,
  });

  factory ElevatorState.fromJson(Map<String, dynamic> json) {
    return ElevatorState(id: json['id'], floor: json['floor'].toInt(), activity: json['activity'], timestamp: json['timestamp'].toDouble());
  }

  Future<void> update() async {
    // TODO: API address
    //print("Hello there. I'm sending an update!!");
    var response = await http.put(Uri.parse("https://api.bru.lu/elevatorstate/update"),
        headers: <String, String> {
          'Content-Type': 'application/json',
          'accept': 'application/json'
        },
        body: jsonEncode({
          "id": id,
          "floor": floor,
          "activity": activity,
          "timestamp": timestamp,
        })
    );
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Failed to update Elevator: " + id);
    }
  }
}

Future<ElevatorState> fetchElevatorState(String esID) async {
  // TODO: API address
  final response = await http.get(Uri.parse('https://api.bru.lu/elevatorstate/' + esID));

  if (response.statusCode == 200) {
    return ElevatorState.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load Elevator State:" + esID);
  }
}