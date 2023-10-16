import 'package:flutter/material.dart';

void main() {
  runApp(MyTaskApp());
}

class MyTaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<Map<String, String>> _tasks = [];

  void _addTask() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    if (title.isEmpty || description.isEmpty) return;

    setState(() {
      _tasks.add({
        'title': title,
        'description': description,
      });
    });

    _titleController.clear();
    _descriptionController.clear();
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showEditDialog(int index) {
    final _editTitleController =
    TextEditingController(text: _tasks[index]['title']);
    final _editDescriptionController =
    TextEditingController(text: _tasks[index]['description']);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            top: 13.0,
            left: 13.0,
            right: 13.0,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 10.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _editTitleController,
                decoration: InputDecoration(labelText: 'Edit Title'),
              ),
              TextField(
                controller: _editDescriptionController,
                decoration: InputDecoration(labelText: 'Edit Description'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _tasks[index]['title'] = _editTitleController.text;
                    _tasks[index]['description'] = _editDescriptionController.text;
                  });
                  Navigator.of(ctx).pop();
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 9,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Add Title',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF45C6C6)),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Add Descrtion',
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF45C6C6)),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: _addTask,
              child: Text('Add Task'),
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (ctx, index) {
                  bool isAssigned = true;

                  return Container(
                    margin: EdgeInsets.only(bottom: isAssigned ? 8.0 : 0.0),
                    child: ListTile(
                      leading: isAssigned
                          ? Container(
                        width: 35.0,
                        height: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      )
                          : null,
                      title: Text(_tasks[index]['title']!),
                      subtitle: Text(_tasks[index]['description']!),
                      trailing: IconButton(
                        icon: Icon(Icons.arrow_forward),
                        onPressed: () {},
                      ),
                      tileColor: isAssigned ? Colors.grey : null,
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              title: Text('Alert'),
                              content: Text('Choose an option'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                    _showEditDialog(index);
                                  },
                                  child: Text(
                                    'Edit',
                                    style: TextStyle(color: Color(0xFF45C6C6)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    _deleteTask(index);
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Text(
                                    'Delete',
                                    style: TextStyle(color: Color(0xFF45C6C6)),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
