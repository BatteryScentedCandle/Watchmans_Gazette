import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/articles_page.dart';
import 'package:watchmans_gazette/screens/login_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
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
                        await signUpUser(
                          email: email,
                          password: password,
                          onSuccess: (message) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Welcome to The Watchman's Gazette",
                                ),
                              ),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ArticlesPage(),
                              ),
                            );
                          },
                          onFail: (message) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          },
                        );
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
                      child: const Text(
                        "Login",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
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

Future<void> signUpUser({
  required String email,
  required String password,
  required Function(String) onSuccess,
  Function(String)? onFail,
}) async {
  try {
    if (email.isEmpty || password.isEmpty) {
      if (onFail != null) {
        onFail("Please complete all inputs before proceeding.");
      }
      return;
    }

    FirebaseFirestore db = FirebaseFirestore.instance;
    UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    String uid = userCredential.user!.uid;
    final userInfo = <String, dynamic>{"email": email, "password": password};

    await db.collection("users").doc(uid).set(userInfo);
    onSuccess("Welcome to The Watchman's Gazette");
  } catch (e) {
    if (onFail != null) {
      onFail("Unable to Sign Up");
    }
    return;
  }
}
