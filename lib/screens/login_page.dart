import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String username = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _inputField(),
              _loginButton(context),
              _signup(),
            ],
          ),
        ),
      ),
    );
  }

  _inputField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: const InputDecoration(hintText: "Username"),
          onChanged: (value) {
            setState(() {
              username = value; // Store username in state
            });
          },
        ),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(hintText: "Password"),
          obscureText: true,
          onChanged: (value) {
            setState(() {
              password = value; // Store password in state
            });
          },
        ),
      ],
    );
  }

  // Login button to authenticate the user
  _loginButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        signInUser(username, password, context);
      },
      child: const Text("Login"),
    );
  }

  // Method to handle user sign-in
  Future<void> signInUser(String username, String password, BuildContext context) async {
    // Implement Firebase authentication logic here
    // For example:
    // try {
    //   UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: username, password: password);
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Login failed")));
    // }
  }

  // Link for signing up
  _signup() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have an account? "),
        TextButton(
          onPressed: () {},
          child: const Text("Sign Up"),
        ),
      ],
    );
  }
}