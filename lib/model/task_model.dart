import 'dart:convert';

Task taskFromMap(String str) => Task.fromMap(json.decode(str));

String taskToMap(Task data) => json.encode(data.toMap());

class Task {
  Task({
    this.id,
    required this.task,
    required this.dateTime,
  });

  final int? id;
  final String? task;
  final DateTime? dateTime;

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        task: json["task"],
        dateTime: json["dateTime"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "task": task,
        "creationDate": dateTime.toString(),
      };
}
