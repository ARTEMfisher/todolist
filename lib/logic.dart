class Task{
  
String time;
String task;
String description;

  Task({required this.time, required this.task, String? description}):description=description??'';

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


List<Task> tasks=[
  Task(time: timeFormating(),
  task: 'Ebat blyat',
  // description: 'спасите меня я заебался писать этот код бляяяяяяяяяяяяяяяяяяяяяяяяяя'
  )
];