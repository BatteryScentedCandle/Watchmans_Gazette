import 'package:flutter/material.dart';
import 'sign_up_page.dart';
import 'login_page.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildHeader(context),

            SizedBox(height: 30),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },

                child: Text('Login', style: TextStyle(color: Colors.black)),
              ),
            ),

            SizedBox(height: 10),

            SizedBox(
              width: 200,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpPage()),
                  );
                },
                child: Text('Sign Up', style: TextStyle(color: Colors.black)),
              ),
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
    child: Column(
      children: [
        Container(width: 300, height: 2, color: Colors.black),

        SizedBox(height: 8),

        Text(
          'THE',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 32,
            fontWeight: FontWeight.w100,
            letterSpacing: 8,
            color: Colors.black,
          ),
        ),

        Text(
          'WATCHMEN\'S',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 45,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.black,
            height: 1.1,
          ),
        ),

        Text(
          'GAZETTE',
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 45,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            color: Colors.black,
          ),
        ),

        SizedBox(height: 8),

        Container(width: 300, height: 2, color: Colors.black),

        SizedBox(height: 10),

        Text(
          'Delivering the latest information on the Sustainable Development Goals ',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Metropolis',
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 1,
            color: Colors.black54,
          ),
        ),
      ],
    ),
  );
}
