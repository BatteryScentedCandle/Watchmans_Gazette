import 'package:flutter/material.dart';

import 'sign_up_page.dart';
import 'login_page.dart';


class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => LoginPage()), //need to fix somehow
                // );
              },
              child: Text('Login'),
            ),
            ElevatedButton(
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => SignUpPage()), //need to fix somehow
                // );
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(16.0),

    alignment: Alignment.center,
    child: Text(
      'The Watchman\'s Gazette',
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
  );
}
