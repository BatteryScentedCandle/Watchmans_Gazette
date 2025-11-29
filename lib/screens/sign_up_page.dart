import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/articles_page.dart';
import 'package:watchmans_gazette/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            // add ui stuff here
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    const SizedBox(height: 50),
                    const Text("Become a Watchman"),
                    const SizedBox(height: 20),
                  ],
                ),
                Column(
                  children: <Widget>[
                    TextField(
                      decoration: const InputDecoration(hintText: "Email"),
                      onChanged: (value) {
                        setState(() {
                          email = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      decoration: const InputDecoration(hintText: "Password"),
                      onChanged: (value) {
                        setState(() {
                          password = value;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await signUpUser(email, password, context);
                      },
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text("Already have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: const Text("Login", style: TextStyle(color: Colors.purple),)
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<User?> signUpUser(
  String email,
  String password,
  BuildContext context,
) async {
  try {

    if (email.isEmpty || password.isEmpty){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all inputs before proceeding.")),
      );
      return null;
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;
    final userInfo = <String, dynamic>{
      "email": email,
      "password": password
    };

    await db.collection("users").doc(uid).set(userInfo);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Welcome to The Watchman's Gazette"),
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ArticlesPage()),
    );

  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Unable to Sign Up")));
    return null;
  }
}
