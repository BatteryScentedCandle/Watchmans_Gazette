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
                    const SizedBox(height: 100),
                    const Text(
                      "Become a Member of \nThe Watchmen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 1,
                        color: Colors.black,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
                Column(
                  children: <Widget>[
                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(fontWeight: FontWeight.normal),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.email_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 25),

                    SizedBox(
                      width: 350,
                      child: TextField(
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(fontWeight: FontWeight.normal),
                          floatingLabelStyle: TextStyle(color: Colors.black),
                          prefixIcon: Icon(Icons.password_rounded),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(16)),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 30),

                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
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
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                        color: Colors.black54,
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },

                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontFamily: 'Metropolis',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1,
                          color: Colors.purple,
                        ),
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
