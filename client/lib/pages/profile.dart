import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final storage = FlutterSecureStorage();
  String username = '';
  String userId = '';
  List<dynamic> posts = [];

  Future<void> getStorage() async {
    final valueId = await storage.read(key: "user_id");
    final valueUser = await storage.read(key: "username");

    setState(() {
      print(valueId);
      username = valueUser ?? "Guest";
      userId = valueId ?? "dnasdnans";
    });

    await getPosts();
  }

  Future<void> getPosts() async {
    final token = await storage.read(key: "jwt_token");

    final response = await http.get(
      Uri.parse('http://localhost:5000/api/v1/users/$userId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      setState(() {
        posts = body["data"]["posts"];
        print(posts);
      });
    }
  }

  Future<void> logout() async {
    await storage.delete(key: "jwt_token");
    await storage.delete(key: "userId");
    await storage.delete(key: "username");
    await storage.delete(key: "email");

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  void initState() {
    super.initState();
    getStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(height: 24),
          Icon(Icons.person, size: 48),
          Text(
            "$username Profile",
            style: TextStyle(fontWeight: FontWeight(600), fontSize: 24),
          ),
          SizedBox(height: 24),
          SizedBox(
            width: double.maxFinite,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red[300],
                minimumSize: Size(2000, 50),
              ),
              onPressed: () {
                logout();
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ),
          SizedBox(height: 24),
          Divider(),
          Expanded(
            child: posts.isEmpty
                ? Text("No posts found")
                : ListView.builder(
                    itemCount: posts.length,
                    itemBuilder: (context, index) {
                      final post = posts[index];

                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              print(post["id"]);
                            },
                            contentPadding: EdgeInsets.all(12.0),
                            trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                post["imageUrl"],
                                width: 90,
                                height: 90,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              post["title"],
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 6),
                                Text(
                                  post["content"],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${post["user"]["username"]} - ${post["category"]["title"]}',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                          Divider(),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
