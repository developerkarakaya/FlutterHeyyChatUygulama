import 'package:flutter/material.dart';
import 'package:whatshapp_clone/core/locater.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:whatshapp_clone/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setUpLocaters();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp Clone',
      theme: ThemeData(
        primaryColor: Colors.lightBlue[900],
        accentColor: Colors.lightBlueAccent,
      ),
      home: WelcomeScreen(),
    );
  }
}
