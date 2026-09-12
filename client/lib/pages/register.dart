import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 96),
              Image.asset(
                "assets/images/book-lover.png",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 24),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Register",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                    Text(
                      "Please register to continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight(400),
                      ),
                    ),
                    SizedBox(height: 24),
                    RegisterForm(),
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

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool togglePass = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
              labelText: "Username",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.person),
              prefixIconColor: Colors.deepPurple[300],
            ),
            keyboardType: TextInputType.text,
            validator: (userValue) {
              if (userValue == null || userValue.isEmpty) {
                return "Username is required";
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.mail),
              prefixIconColor: Colors.deepPurple[300],
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (emailValue) {
              if (emailValue == null || emailValue.isEmpty) {
                return "Email is required";
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              labelText: "Password",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              prefixIcon: Icon(Icons.lock),
              prefixIconColor: Colors.deepPurple[300],
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    togglePass = !togglePass;
                    // print(togglePass);
                  });
                },
                icon: Icon(
                  togglePass ? Icons.visibility : Icons.visibility_off,
                ),
              ),
              suffixIconColor: Colors.deepPurple[300],
            ),
            obscureText: togglePass,
            keyboardType: TextInputType.text,
            validator: (passValue) {
              if (passValue == null || passValue.isEmpty) {
                return "Password is required";
              }
              return null;
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple[300],
              minimumSize: Size(2000, 50),
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final response = await http.post(
                  Uri.parse('http://localhost:5000/api/v1/auth/register'),
                  headers: {'Content-type': 'application/json'},
                  body: jsonEncode({
                    'username': usernameController.text,
                    'email': emailController.text,
                    'password': passwordController.text,
                  }),
                );

                final body = jsonDecode(response.body);

                if (!mounted) return;

                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(body['message'])));
              }
            },

            child: Text(
              "Register",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Already have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text("Sign in"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
