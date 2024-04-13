import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class Task {
  String time;
  String task;
  String description;
  bool priority;

  Task({
    required this.time,
    required this.task,
    String? description,
    required this.priority
  }) : description = description ?? '';

  
  Map<String, dynamic> toJson() {
    return {
      'time': time,
      'task': task,
      'description': description,
      'priority' : priority,
    };
  }

  
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      time: json['time'],
      task: json['task'],
      description: json['description'],
      priority: json['priority'],
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






bool priority = false;

class PriorityButton extends StatefulWidget {
  const PriorityButton({super.key});

  @override
  State<PriorityButton> createState() => _PriorityButtonState();
}

class _PriorityButtonState extends State<PriorityButton> {
  @override
  Widget build(BuildContext context) {
    return priority?Text("Задача сделана приоритетной"):
      OutlinedButton(
                    
        onPressed: (){
        priority= !priority;
        print(priority);
        setState(() {
          
        });

      }, 
      child: Text("Сделать приоритетной задачей",style: TextStyle(
        fontWeight: FontWeight.w200
      ),));
  }
}



