import 'package:flutter/material.dart';
import 'package:flutter_application_works/db/db_provider.dart';
import 'package:flutter_application_works/model/task_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyTodoApp(),
    );
  }
}

class MyTodoApp extends StatefulWidget {
  const MyTodoApp({Key? key}) : super(key: key);

  @override
  State<MyTodoApp> createState() => _MyTodoAppState();
}

class _MyTodoAppState extends State<MyTodoApp> {
  Color mainColor = const Color(0xFF0d0952);
  Color secondColor = const Color(0xFF212061);
  Color buttonColor = const Color(0xFFff955b);
  Color editorColor = const Color(0xFF4044cc);

  TextEditingController inputController = TextEditingController();
  String newTaskTxt = "";

  //Getting getAll func from DBProvider
  Future<List<dynamic>> getTasks() async {
    final tasks = await DBProvider.dataBase.getTask();
    // ignore: avoid_print
    print(tasks);
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: mainColor,
        title: const Text('My ToDo App'),
      ),
      backgroundColor: mainColor,
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: getTasks(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    {
                      return const Center(child: CircularProgressIndicator());
                    }
                  case ConnectionState.done:
                    {
                      if (snapshot.data!.isNotEmpty) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              String task =
                                  snapshot.data![index]['task'].toString();
                              String day = DateTime.parse(
                                      snapshot.data![index]['creationDate'])
                                  .day
                                  .toString();
                              return Card(
                                color: secondColor,
                                child: InkWell(
                                  onDoubleTap: () {
                                    setState(() {
                                      int id = snapshot.data![index]['id'];
                                      DBProvider.dataBase.deleteTask(id);
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        margin:
                                            const EdgeInsets.only(right: 12),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          day,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          task,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return const Center(
                          child: Text(
                            'Bugünlük yapılacak bir etkinlik yok',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                      }
                    }
                  default:
                    return const Center(
                      child: Text(
                        'Bugünlük yapılacak bir etkinlik yok',
                        style: TextStyle(color: Colors.white),
                      ),
                    );
                }
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(color: editorColor),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: inputController,
                    cursorColor: buttonColor,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Add new task',
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      newTaskTxt = inputController.text.toString();
                      inputController.text = "";
                    });
                    Task newTask =
                        Task(task: newTaskTxt, dateTime: DateTime.now());
                    DBProvider.dataBase.addNewTask(newTask);
                  },
                  icon: const Icon(Icons.add),
                  color: buttonColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
