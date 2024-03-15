import 'package:flutter/material.dart';
import 'package:todolist/logic.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme:ThemeData.dark(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home:App()
    );
  }
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String? _task;
  String? _description;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          
          children: <Widget>[
          
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              foregroundImage: AssetImage('data/mai.jpg'),
              radius: 25,
            ),
          )
        ]),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext context, int index)=>Card(
          child:ListTile(
            leading: Text(tasks[index].task),
            trailing: Text(tasks[index].time),
            onTap: (){
              showDialog(context: context,
               builder: (BuildContext context)=>AlertDialog(
                  title: Column(
                    children: [
                      Text(tasks[index].task),
                      Text("Добавлено ${tasks[index].time.toString()}")
                    ],
                  ),
                  content: (tasks[index].description!='')?Text(tasks[index].description):null,
        
               )
               );
            },
            onLongPress: (){
              setState(() {
                tasks.removeAt(index);
              });
            },
          )
        )
        
        
        ),
      bottomNavigationBar: BottomAppBar(
        child: TextButton.icon(
            icon: const Icon(Icons.add),
            label: const Text("Добавить задачу",style: TextStyle(fontSize: 20),),
            onPressed: (){
              showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
                content: Form( 
                  key: _formKey, 
                  
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Задача',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста, введите задачу';
                          }
                          return null;
                        },
                        onSaved: (value){
                          _task = value;
                        },
                      ),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: const InputDecoration(
                          hintText: 'Заметка к задаче',
                          border: OutlineInputBorder()
                        ),
                        onSaved: (value){
                          _description = value;
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  OutlinedButton(
                    onPressed: (){
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_task != null && _task != '') {
                          setState(() {
                            tasks.add(
                              Task(
                                time: timeFormating(),
                                task: _task.toString(),
                                description: _description
                              )
                            );
                            print(tasks);
                          });
                          Navigator.of(context).pop(); 
                        }
                      }
                    },
                    child: Text("Добавить задачу")
                  )
                ],
              )
            );
            }, 
            )
            
      ),
    );
  }
}

// Text(tasks[index].time.toString()