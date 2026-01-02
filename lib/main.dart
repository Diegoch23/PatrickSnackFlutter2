import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(PatricksApp());
}

class PatricksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Patrik's Snack Stock",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.orange),
      home: LoginScreen(), // Aquí empezarás
    );
  }
}