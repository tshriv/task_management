import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:task_management_app/AddEditTaskWidget.dart';
import 'package:task_management_app/HomePage.dart';
import 'package:task_management_app/main.dart';

class TaskDetailWidget extends StatefulWidget {
  String title;
  String description;
  bool isCompleted;
  String docId;

  TaskDetailWidget({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.docId,
  });

  @override
  State<TaskDetailWidget> createState() => TaskDetailWidgetState();
}

class TaskDetailWidgetState extends State<TaskDetailWidget> {
  bool showloadingForDelete = false;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteDocument(String documentId) async {
    try {
      CollectionReference collection =
          FirebaseFirestore.instance.collection("tasks");
      setState(() {
        showloadingForDelete = true;
      });
      await collection.doc(documentId).delete();
      setState(() {
        showloadingForDelete = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Deleted')),
      );
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
          (route) => false);
    } catch (e) {
      print('Error deleting document: $e');
    }
  }

  void updateTaskDetail(String title, String description, String status) {
    setState(() {
      widget.title = title;
      widget.description = description;
      print("iscompleted status = $status");
      if (status == "Done") {
        widget.isCompleted = true;
      } else
        widget.isCompleted = false;
    });
  }

  Future<void> markAsDone() async {
    try {
      DocumentReference taskRef =
          _firestore.collection('tasks').doc(widget.docId);

      await taskRef.update({
        'title': widget.title,
        'description': widget.description,
        "isCompleted": true
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Done')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Task Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskAddEditWidget(
                      title: widget.title,
                      description: widget.description,
                      isCompleted: widget.isCompleted,
                      isEditRequest: true,
                      docId: widget.docId,
                      updateTaskDetail: updateTaskDetail,
                    ),
                  ));
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Show delete confirmation dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Delete'),
                    content: const Text(
                        'Are you sure you want to delete this task?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close dialog
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          deleteDocument(widget.docId);
                        },
                        child: !showloadingForDelete
                            ? Text('Delete')
                            : CircularProgressIndicator(),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 20,
              ),
              const Text(
                " Status:",
                style: TextStyle(
                    // color: Color.fromARGB(255, 126, 126, 126),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                decoration: BoxDecoration(
                  color: widget.isCompleted ? Colors.green : Colors.redAccent,
                  borderRadius: BorderRadius.circular(10), // Rounded corners
                ),
                child: Text(
                  widget.isCompleted ? 'Done' : 'Pending',
                  style: const TextStyle(color: Colors.white, fontSize: 14
                      // fontWeight: FontWeight.,
                      ),
                ),
              ),
              Container(
                height: 20,
              ),
              const Text(
                " Title:",
                style: TextStyle(
                    // color: Color.fromARGB(255, 126, 126, 126),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 8,
              ),
              Container(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                      color: const Color.fromARGB(255, 240, 238, 234)),
                  child: Text(
                    widget.title,
                  ),
                ),
              ),
              Container(
                height: 20,
              ),
              const Text(
                " Description:",
                style: TextStyle(
                    // color: Color.fromARGB(255, 126, 126, 126),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
              Container(
                height: 8,
              ),
              Container(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                      color: const Color.fromARGB(255, 240, 238, 234)),
                  child: Text(
                    widget.description,
                  ),
                ),
              ),
              Container(
                height: 10,
              ),
              !widget.isCompleted?
              ElevatedButton(
                  onPressed: markAsDone,
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.check),
                      SizedBox(width: 8.0),
                      Text("Mark as Done"),
                    ],
                  )):Container()
            ],
          ),
        ),
      ),
    );
  }
}
