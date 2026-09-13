import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
  String username = '';

  Future<void> getStorage() async {
    final value = await storage.read(key: "jwt_token");

    setState(() {
      username = value ?? "Guest";
    });
  }

  @override
  void initState() {
    super.initState();
    getStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schologg",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight(600)),
        ),
        backgroundColor: Colors.deepPurple[300],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(username),
      )
    );
  }
}
