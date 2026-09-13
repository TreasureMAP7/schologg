import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final storage = FlutterSecureStorage();
  final queryController = TextEditingController();
  String username = '';
  List<dynamic> posts = [];

  Future<void> getStorage() async {
    final value = await storage.read(key: "username");

    setState(() {
      username = value ?? "Guest";
    });
  }

  Future<void> getPosts() async {
    final response = await http.get(
      Uri.parse(
        'http://localhost:5000/api/v1/posts?searchQuery=${queryController.text}',
      ),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      setState(() {
        posts = body["data"]["posts"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStorage();
    getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          TextFormField(
            controller: queryController,
            decoration: InputDecoration(
              labelText: "Search",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  getPosts();
                },
                icon: Icon(Icons.search),
              ),
              suffixIconColor: Colors.deepPurple[300],
            ),
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 24),
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
