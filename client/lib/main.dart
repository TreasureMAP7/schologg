import 'package:client/pages/create.dart';
import 'package:client/pages/detail.dart';
import 'package:client/pages/edit.dart';
import 'package:client/pages/home.dart';
import 'package:client/pages/login.dart';
import 'package:client/pages/main_page.dart';
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
        "/main": (context) => MainPage(),
        "/home": (context) => HomePage(),
        "/detail": (context) => DetailPage(),
        "/create": (context) => CreatePostPage(),
        "/edit": (context) => EditPostPage(),
      },
      initialRoute: "/register",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: "Inter"),
    );
  }
}
