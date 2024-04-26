//source: https://docs.flutter.dev/cookbook/design/drawer
//source: https://chat.openai.com/

import 'package:flutter/material.dart';

void main() {
  //run the main app widget
  runApp(TodoListApp());
}

Map<String, List<TodoTask>> todoLists = {
  'Personal': [],
  'Work': [],
  'Shopping': [],
};

String _currentList = 'Personal';

//set up the MaterialApp
class TodoListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To-Do List',
      theme: ThemeData(primarySwatch: Colors.blueGrey),
      //home page of the app
      home: TodoList(),
    );
  }
}

//stateful widget to be able to change it dynamically
class TodoList extends StatefulWidget {
  @override
  //creates an instance of _TodoListState
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  //adds a task to the list
  void _addTask(String task) {
    setState(() {
      todoLists[_currentList]!.add(TodoTask(task));
    });
  }

  //toggle between complete and undo
  void _completeTask(int index) {
    setState(() {
      todoLists[_currentList]![index].isComplete = !todoLists[_currentList]![index].isComplete;
    });
    _checkCompletion();
  }

  //remove all tasks in the list
  void _clearAllTasks() {
    setState(() {
      todoLists[_currentList]!.clear();
    });
  }

  //remove current task in the list
  void _removeTask(int index) {
    setState(() {
      todoLists[_currentList]!.removeAt(index);
    });
    _checkCompletion();
  }

  //check if all tasks have been completed (true)
  void _checkCompletion() {
    if (todoLists[_currentList]!.every((task) => task.isComplete) && todoLists[_currentList]!.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Congratulations!"),
            content: Text("Yay! You have completed all tasks."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    int incompleteTasksCount = todoLists[_currentList]!.where((task) => !task.isComplete).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly To-Do List', style: TextStyle(color: Colors.blueGrey, fontSize: 32)),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blueGrey),
              child: Text('My To-Do Lists', style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            for (String listName in todoLists.keys)
              ListTile(
                title: Text(listName),
                onTap: () {
                  setState(() {
                    _currentList = listName;
                  });
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tasks Left To-Do: $incompleteTasksCount', style: TextStyle(fontSize: 16, color: Colors.black)),
                TextButton(
                  onPressed: _clearAllTasks,
                  child: Text('Clear All', style: TextStyle(color: Colors.red, fontSize: 16)),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: todoLists[_currentList]!.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(
                      todoLists[_currentList]![index].task,
                      style: TextStyle(
                        decoration: todoLists[_currentList]![index].isComplete ? TextDecoration.lineThrough : null,
                        fontSize: 20,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(todoLists[_currentList]![index].isComplete ? Icons.undo : Icons.check),
                          color: todoLists[_currentList]![index].isComplete ? Colors.grey : Colors.green,
                          onPressed: () => _completeTask(index),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _removeTask(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(),
          ListTile(
            title: TextField(
              decoration: InputDecoration(labelText: 'Add Task To List'),
              onSubmitted: (value) {
                _addTask(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}

//class to represent the task
class TodoTask {
  //the name of the task
  String task;
  //is the task complete or not
  bool isComplete;

  //constructor
  TodoTask(this.task, {this.isComplete = false});
}
