import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final storage = FlutterSecureStorage();
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
      Uri.parse('http://localhost:5000/api/v1/posts'),
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
      child: ListView.builder(
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
    );
  }
}

// ListTile(
//               contentPadding: EdgeInsets.all(12.0),
//               leading: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: Image.network(
//                   'https://images.unsplash.com/photo-1559827260-dc66d52bef19',
//                   width: 90,
//                   height: 90,
//                   fit: BoxFit.cover,
//                 ),
//               ),
//               title: Text(
//                 username,
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               subtitle: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(height: 6),
//                   Text(
//                     'Sungguh indah memang orca itu dan mereka sangat menarik untuk dibahas...',
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     '@miftahakhdani • Animal',
//                     style: TextStyle(fontSize: 12),
//                   ),
//                 ],
//               ),
//             ),
