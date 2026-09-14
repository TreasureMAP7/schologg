import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:image_picker/image_picker.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final storage = FlutterSecureStorage();
  String? category;
  List<dynamic> data = [];
  List<String> categories = [];

  final ImagePicker picker = ImagePicker();

  XFile? selectedImage;
  Uint8List? imageBytes;

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
      });
    }
  }

  Future<void> createPost() async {
    final token = await storage.read(key: "jwt_token");
    final userId = await storage.read(key: "user_id");

    final request = http.MultipartRequest(
      "POST",
      Uri.parse("http://localhost:5000/api/v1/posts"),
    );

    request.headers.addAll({"Authorization": "Bearer $token"});

    request.fields["title"] = titleController.text;
    request.fields["content"] = contentController.text;
    request.fields["categoryId"] = "${categories.indexOf(category!) + 1}";
    request.fields["userId"] = userId!;

    if (selectedImage != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          "image",
          imageBytes!,
          filename: selectedImage!.name,
          contentType: MediaType("image", "jpeg"),
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Post created succesfully')));
      Navigator.pushNamedAndRemoveUntil(context, "/main", (route) => false);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Post creation failed: Error ${response.statusCode}'),
        ),
      );
    }

    print("BODY: ${await response.stream.bytesToString()}");
  }

  Future<void> pickImage() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    final bytes = await image.readAsBytes();

    setState(() {
      selectedImage = image;
      imageBytes = bytes;
    });
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Post'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title",
                hintText: "Insert your post title",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: contentController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: "Content",
                hintText: "Insert your post content",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 24),
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
                  print(category);
                },
              ),
            ),
            SizedBox(height: 24),
            Text("Select Image"),
            SizedBox(height: 8),
            GestureDetector(
              onTap: pickImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: imageBytes == null
                    ? Container(
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 45,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : Image.memory(
                        imageBytes!,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
              ),
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                createPost();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple[300],
                minimumSize: Size(2000, 50),
              ),
              child: Text(
                "Create Post",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
