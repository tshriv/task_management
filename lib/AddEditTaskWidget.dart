import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskAddEditWidget extends StatefulWidget {
  final String? title;
  final String? description;
  final bool? isCompleted;
  final bool isEditRequest;
  final String? docId;
  final void Function(String, String, String)? updateTaskDetail;

  TaskAddEditWidget(
      {this.title,
      this.description,
      this.isCompleted,
      this.docId,
      required this.isEditRequest,
      this.updateTaskDetail});

  @override
  State<TaskAddEditWidget> createState() => TaskAddEditWidgetState();
}

class TaskAddEditWidgetState extends State<TaskAddEditWidget> {
  TextEditingController? titleController, descriptionController;
  String? selectedStatus;
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool showloading = false;

  Future<void> updateData(
      String title, String description, String isCompleted) async {
    try {
      DocumentReference taskRef =
          _firestore.collection('tasks').doc(widget.docId);
      setState(() {
        showloading = true;
      });
      await taskRef.update({
        'title': title,
        'description': description,
        "isCompleted": isCompleted == "Done" ? true : false
      });

      setState(() {
        showloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task Updated')),
      );
      widget.updateTaskDetail!(title, description, isCompleted);
      Navigator.pop(context);
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  Future<void> addNewTask(
      String title, String description, String isCompleted) async {
    try {
      CollectionReference tasks = _firestore.collection('tasks');
      setState(() {
        showloading = true;
      });
      await tasks.add({
        'title': title,
        'description': description,
        "isCompleted": isCompleted == "Done" ? true : false
      });

      setState(() {
        showloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('New Task Added')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating document: $e');
    }
  }

  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    descriptionController = TextEditingController(text: widget.description);
    selectedStatus = widget.isCompleted == true ? "Done" : "Pending";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.isEditRequest ? "Edit Task" : "Add New Task"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: DropdownButton<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedStatus = newValue;
                      });
                    },
                    items: <String>['Done', 'Pending'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
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
                Container(height: 8,),
                TextFormField(
                  controller: titleController,
                  maxLines: 2,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                // Container(
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(2),
                //         ),
                //         color: const Color.fromARGB(255, 240, 238, 234)),
                //     child: Text(
                //       widget.title,
                //     ),
                //   ),
                // ),
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
                 Container(height: 8,),
                TextFormField(
                  maxLines: 8,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                  // decoration: InputDecoration(border: InputBorder.none),
                  controller: descriptionController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                ),
                Container(height: 20,),
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            widget.isEditRequest
                                ? updateData(
                                    titleController?.text ?? "",
                                    descriptionController?.text ?? "",
                                    selectedStatus ?? "")
                                : addNewTask(
                                    titleController?.text ?? "",
                                    descriptionController?.text ?? "",
                                    selectedStatus ?? "");
                          }
                        },
                        child: !showloading
                            ? Text(widget.isEditRequest
                                ? "Update Task"
                                : "Create Task")
                            : Container(height:20,width: 20, child: CircularProgressIndicator()))
                  ],
                )
                // Container(
                //   child: Container(
                //     width: MediaQuery.of(context).size.width * 0.9,
                //     padding: const EdgeInsets.fromLTRB(8, 8, 12, 12),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.all(
                //           Radius.circular(2),
                //         ),
                //         color: const Color.fromARGB(255, 240, 238, 234)),
                //     child: Text(
                //       widget.description,
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
