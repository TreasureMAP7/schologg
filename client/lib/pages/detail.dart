import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final storage = FlutterSecureStorage();

  Future<void> deletePost(int postId) async {
    final token = await storage.read(key: "jwt_token");

    final response = await http.delete(
      Uri.parse("http://localhost:5000/api/v1/posts/$postId"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post deleted succesfully')));
      Navigator.pushNamedAndRemoveUntil(context, "/main", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post deletion failed: Error ${response.statusCode}'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<dynamic, dynamic>;

    final post = args["post"];
    final isEditable = args["isEditable"] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: isEditable ? Text("Your Post") : Text("Detail Post"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              post["imageUrl"] != null
                  ? Image.network(
                      post["imageUrl"],
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.contain,
                    )
                  : const SizedBox(
                      width: double.infinity,
                      height: 150,
                      child: Icon(Icons.image_not_supported_outlined),
                    ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.purple.shade50,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        post["category"]["title"],
                        style: TextStyle(
                          color: Colors.purple,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      post["title"],
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text("By", style: TextStyle(color: Colors.grey)),
                        SizedBox(width: 6),
                        Text(
                          "@${post["user"]["username"]}",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),
                    Text(
                      post["content"],
                      textAlign: TextAlign.justify,
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                    SizedBox(height: 24),
                    isEditable
                        ? SizedBox(
                            width: double.maxFinite,
                            child: Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple[300],
                                    minimumSize: Size(2000, 50),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit',
                                      arguments: {'post': post},
                                    );
                                  },
                                  child: Text(
                                    "Edit Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 12),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[300],
                                    minimumSize: Size(2000, 50),
                                  ),
                                  onPressed: () {
                                    deletePost(post["id"]);
                                  },
                                  child: Text(
                                    "Delete Post",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Divider(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
