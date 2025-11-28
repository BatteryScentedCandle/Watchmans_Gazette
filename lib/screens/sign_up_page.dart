import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget{
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState() ;

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
                      const Text("Sign Up"),
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
                ],
              ),
            ),
          ),
        ),
      );
    }
  }


  Future<User?> signUpUser(String email, String password, BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Unable to Sign Up"),
        ),
      );
      return null;
    }
  }
