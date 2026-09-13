import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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
                      "Login",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight(600),
                      ),
                    ),
                    Text(
                      "Please login to continue",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight(400),
                      ),
                    ),
                    SizedBox(height: 24),
                    LoginForm(),
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

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final formKey = GlobalKey<FormState>();
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
                print("Hai");

                final response = await http.post(
                  Uri.parse('http://localhost:5000/api/v1/auth/login'),
                  headers: {'Content-type': 'application/json'},
                  body: jsonEncode({
                    'email': emailController.text,
                    'password': passwordController.text,
                  }),
                );

                final body = jsonDecode(response.body);

                if (!mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      body["success"] ? "Login Berhasil" : "Login gagal",
                    ),
                  ),
                );
              }
            },

            child: Text(
              "Login",
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don't have an account?"),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/register');
                },
                child: const Text("Sign up"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
