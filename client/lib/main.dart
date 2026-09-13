import 'package:client/pages/login.dart';
import 'package:client/pages/register.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        "/register": (context) => RegisterPage(),
        "/login": (context) => LoginPage(),
      },
      initialRoute: "/register",
    );
  }
}
