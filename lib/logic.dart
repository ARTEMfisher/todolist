import 'dart:convert';
import 'dart:io';

class Task {
  String time;
  String task;
  String description;

  Task({
    required this.time,
    required this.task,
    String? description,
  }) : description = description ?? '';

  
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'task': task,
      'description': description,
    };
  }

  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      time: json['time'],
      task: json['task'],
      description: json['description'],
    );
  }
}


Future<void> saveTasks(List<Task> tasks, String filePath) async {
  final file = File(filePath);
  final jsonList = tasks.map((task) => task.toJson()).toList();
  await file.writeAsString(jsonEncode(jsonList));
}


Future<List<Task>> loadTasks(String filePath) async {
  final file = File(filePath);
  if (!await file.exists()) {
    return []; 
  }
  final jsonString = await file.readAsString();
  final jsonList = jsonDecode(jsonString) as List;
  return jsonList.map((json) => Task.fromJson(json)).toList();
}




String timeFormating(){
  DateTime now = DateTime.now();
  DateTime roundedTime = DateTime(
  now.year,
  now.month,
  now.day,
  now.hour,
  now.minute,
);
  return roundedTime.toString().substring(0, 16);
}






List<Task> tasks=[];