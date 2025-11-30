import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:watchmans_gazette/screens/landing_page.dart';

class UserProfilePage extends StatefulWidget{
  const UserProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          //TODO: add change password
          SizedBox(
            width: 50,
            height: 50,
            child: ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LandingPage(),
                    ),
                  );
            }, child: Text('Sign Out', style: TextStyle(color: Colors.black),),
            ),
          )
        ],
      ),
    );
  }

}

Widget _buildHeader(BuildContext context) {
  User? user = FirebaseAuth.instance.currentUser;

  return Container(
    padding: EdgeInsets.all(16.0),

    alignment: Alignment.center,
    child: Column(
      children: [
        Container(width: 300, height: 2, color: Colors.black),

        SizedBox(height: 8),

        Text(
          '${user?.email}',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 32,
            fontWeight: FontWeight.w100,
            letterSpacing: 8,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}