import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchmans_gazette/screens/main_screen.dart';
import 'package:watchmans_gazette/screens/sign_up_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const SizedBox(height: 100),
                  const Text(
                    "Welcome Back to \nThe Watchman's Gazette",
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
                        floatingLabelStyle: TextStyle(color: Color(0xFFB87A7A)),
                        prefixIcon: Icon(Icons.email_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Color(0xFFD4C4B0),
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
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 350,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(fontWeight: FontWeight.normal),
                        floatingLabelStyle: TextStyle(color: Color(0xFFB87A7A)),
                        prefixIcon: Icon(Icons.password_rounded),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                          borderSide: BorderSide(
                            color: Color(0xFFD4C4B0),
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
                        await loginUser(
                          email: email,
                          password: password,
                          onSuccess: (message) {
                            Navigator.pop(context);
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainScreen(),
                              ),
                            );

                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          },
                          onFail: (message) {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(SnackBar(content: Text(message)));
                          },
                        );
                      },
                      child: const Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    "Don't have an account?",
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
                        MaterialPageRoute(builder: (context) => SignUpPage()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1,
                        color: Color(0xFFC4B0DC),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> loginUser({
  required String email,
  required String password,
  required Function(String) onSuccess,
  Function(String)? onFail,
}) async {
  if (email.isEmpty || password.isEmpty) {
    if (onFail != null) {
      onFail("Please complete all inputs before proceeding.");
    }
    return;
  }

  try {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    UserCredential userCredential = await auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    String uid = userCredential.user!.uid;

    DocumentSnapshot userDoc = await firestore
        .collection('users')
        .doc(uid)
        .get();
    if (!userDoc.exists) {
      if (onFail != null) {
        onFail("User does not exist");
      }
      return;
    }

    onSuccess("Welcome to The Watchman's Gazette");

  } catch (e) {
    if (onFail != null) {
      onFail("Unable to Log In");
    }
    return;
  }
}
