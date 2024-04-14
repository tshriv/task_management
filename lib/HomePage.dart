import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/AddEditTaskWidget.dart';
import 'package:task_management_app/TaskDetailWidget.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Task Manager"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new screen (NewScreen) when FAB is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TaskAddEditWidget(isEditRequest: false,)),
          );
        },
        child: Icon(Icons.add),
      ),
      // body: Container(),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('tasks').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final docs = snapshot.data!.docs;
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (ctx, index) {
              final title = docs[index]['title'];
              final description = docs[index]['description'];
              final isTaskDone = docs[index]['isCompleted'];
              final docId= docs[index].id;
              return Card(
                elevation: 2,
                color: !isTaskDone?  Color.fromARGB(255, 210, 225, 245):Colors.white,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailWidget(
                            title: title,
                            description: description,
                            isCompleted: isTaskDone,
                            docId:docId
                          ),
                        ));
                  },
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(isTaskDone?"Done":"Pending",style: TextStyle(color:isTaskDone? Colors.green:Colors.red,fontSize: 12),),
                        Text(title , maxLines: 2,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
                      ],
                    ),
                    subtitle: Text(description, maxLines: 3,overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 13),),
                    trailing: Icon(Icons.arrow_circle_right),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}