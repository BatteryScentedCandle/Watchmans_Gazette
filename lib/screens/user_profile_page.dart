import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/landing_page.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<StatefulWidget> createState() => _UserProfilePage();
}

class _UserProfilePage extends State<UserProfilePage> {
  User? user;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                _changePasswordField(context);
              },
              child: Text(
                'Change Password',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Text('Sign Out', style: TextStyle(color: Colors.black)),
            ),
          ),
          SizedBox(
            width: 100,
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                await user!
                    .delete(); //TODO: add confirmation before proceeding with deletion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LandingPage()),
                );
              },
              child: Text(
                'Delete Account',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
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

Future<void> _changePasswordField(context) async {
  String currentPassword = '';
  String newPassword = '';

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'Current Password'),
              onChanged: (value) {
                currentPassword = value;
              },
            ),
            TextField(
              obscureText: true,
              decoration: InputDecoration(hintText: 'New Password'),
              onChanged: (value) {
                newPassword = value;
              },
            ),
          ],
        ),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await _changePassword(currentPassword, newPassword, context);
              Navigator.of(context).pop();
            },
            child: Text('Change'),
          ),
        ],
      );
    },
  );
}

Future<void> _changePassword(
  String currentPassword,
  String newPassword,
  context,
) async {
  User? user = await FirebaseAuth.instance.currentUser;

  AuthCredential credential = EmailAuthProvider.credential(
    email: user!.email!,
    password: currentPassword,
  );

  await user
      .reauthenticateWithCredential(credential)
      .then((_) {
        return user.updatePassword(newPassword);
      })
      .then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password changed successfully!')),
        );
      })
      .catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Password not changed due to ${error.toString()}'),
          ),
        );
      });
}
