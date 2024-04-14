import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_management_app/AddEditTaskWidget.dart';
import 'package:task_management_app/HomePage.dart';
import 'package:task_management_app/TaskDetailWidget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyCR9Oun03p0ISTGRRi73k2XQme66DclA4U",
          appId: "1:136902183715:android:faac3fc219c116a224da96",
          messagingSenderId: "136902183715",
          projectId: "task-management-e83a0"));

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}
