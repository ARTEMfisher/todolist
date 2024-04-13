import 'package:flutter/material.dart';
import 'package:todolist/logic.dart';
import 'package:todolist/style.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  Directory appDir = await getApplicationDocumentsDirectory();
  String filePath = '${appDir.path}/tasks.json';

  List<Task> tasks = await loadTasks(filePath);

  runApp(MyApp(tasks: tasks, filePath: filePath));
}

class MyApp extends StatelessWidget {
  final List<Task> tasks;
  final String filePath;

  const MyApp({Key? key, required this.tasks, required this.filePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: App(tasks: tasks, filePath: filePath),
    );
  }
}

class App extends StatefulWidget {
  final List<Task> tasks;
  final String filePath;

  const App({Key? key, required this.tasks, required this.filePath}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? _task;
  String? _description;
    
  late int indexNum;
  late SharedPreferences _prefs;
  

  final _formKey = GlobalKey<FormState>();

Future<void> loadIndex() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      indexNum = _prefs.getInt('number') ?? 0;
    });
  }

  Future<void> saveIndex(int number) async {
    await _prefs.setInt('number', number);
  }


  @override
  void initState() {
    super.initState();
    loadIndex(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.only(left: 6),
          child: CircleAvatar(
            foregroundImage: AssetImage('data/mai.jpg'),
            radius: 25,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.tasks.length,
        itemBuilder: (BuildContext context, int index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Card(
            child: ListTile(
              leading: Text(widget.tasks[index].task,style: taskStyle,),
              trailing: Text(widget.tasks[index].time, style: timeStyle),
              subtitle: widget.tasks[index].priority?const Text("ПРИОРИТЕТНАЯ ЗАДАЧА"):null,
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Column(
                      children: [
                        Text(widget.tasks[index].task, style:alertTitleStyle),
                        Text("Добавлено ${widget.tasks[index].time}",style:alertTimeStyle)
                      ],
                    ),
                    content: (widget.tasks[index].description != '')
                        ? Text(widget.tasks[index].description)
                        : null,
                  ),
                );
              },
              onLongPress: () {
                showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                  content: const Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Вы уверены, что хотите удалить задачу?")
                    ]),
                    actions: <Widget>[
                      OutlinedButton(onPressed: (){
                        setState(() {
                          if(widget.tasks[index].priority==true){
                            setState(() {
                              indexNum--;
                              saveIndex(indexNum);
                            });
                          }

                       widget.tasks.removeAt(index);

                      saveTasks(widget.tasks, widget.filePath); 
                      Navigator.of(context).pop();
                });
                      }, 
                      child: Text("Да")),
                      OutlinedButton(onPressed: (){
                        Navigator.of(context).pop();
                      }, 
                      child: Text("Нет"))
                    ],
                ));
                
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton.icon(
          icon: const Icon(Icons.add),
          label: const Text(
            "Добавить задачу",
            style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                content: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextFormField(
                        maxLength: 20,
                        decoration: const InputDecoration(
                          hintText: 'Задача',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите задачу';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _task = value;
                        },
                      ),
                      const SizedBox(height: 10,),
                      TextFormField(
                        maxLength: 500,
                        decoration: const InputDecoration(
                          hintText: 'Заметка к задаче',
                          hintStyle: TextStyle(fontWeight: FontWeight.w300),
                          border: OutlineInputBorder()
                        ),
                        onSaved: (value) {
                          _description = value;
                        },
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  PriorityButton(),
                  OutlinedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_task != null && _task != '') {
                          setState(() {
                            priority?
                            widget.tasks.insert(0,
                              Task(
                                time: timeFormating(),
                                task: _task.toString(),
                                description: _description,
                                priority: priority
                              )
                            ):
                            widget.tasks.insert(indexNum,Task(
                                time: timeFormating(),
                                task: _task.toString(),
                                description: _description,
                                priority: priority
                              ) );
                            if (priority==true){
                              setState(() {
                                indexNum++;
                              });
                              saveIndex(indexNum);
                            }
                            saveTasks(widget.tasks, widget.filePath);
                            priority=false;
                            
                          });
                          Navigator.of(context).pop(); 
                        }
                      }
                    },
                    child: Text("Добавить задачу",style: const TextStyle(
                      fontWeight: FontWeight.w200
                    ),)
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
