import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  final storage = FlutterSecureStorage();
  String? category;
  String username = '';
  List<dynamic> data = [];
  List<String> categories = [];
  List<dynamic> posts = [];

  Future<void> getStorage() async {
    final value = await storage.read(key: "username");

    setState(() {
      username = value ?? "Guest";
    });
  }

  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse('http://localhost:5000/api/v1/posts/categories'),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      setState(() {
        data = body["data"]["categories"];
        categories = data.reversed
            .map((category) => category["title"].toString())
            .toList();
        getPosts();
      });
    }
  }

  Future<void> getPosts() async {
    print(categories);
    print(category);

    final response = await http.get(
      category == null
          ? Uri.parse('http://localhost:5000/api/v1/posts')
          : Uri.parse(
              'http://localhost:5000/api/v1/posts?categoryId=${categories.indexOf(category!) + 1}',
            ),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(category);

      setState(() {
        posts = body["data"]["posts"];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getStorage();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: DropdownButton(
              hint: Text("Choose category"),
              value: category,
              isExpanded: true,
              items: categories.map((val) {
                return DropdownMenuItem(value: val, child: Text(val));
              }).toList(),
              onChanged: (value) {
                setState(() => category = value!);
                setState(() {
                  getPosts();
                });
              },
            ),
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
                              Navigator.pushNamed(
                                context,
                                '/detail',
                                arguments: {'post': post, "isEditable": false},
                              );
                            },
                            contentPadding: EdgeInsets.all(12.0),
                            trailing: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: post["imageUrl"] != null
                                  ? Image.network(
                                      post["imageUrl"],
                                      width: 90,
                                      height: 90,
                                      fit: BoxFit.cover,
                                    )
                                  : const SizedBox(
                                      width: 90,
                                      height: 90,
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                      ),
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
