import 'package:flutter/material.dart';

import 'articles_page.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArticlesPage()),
                );
              },
              child: Text('Take but a peek of our affairs'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHeader() {
  return Container(
    padding: EdgeInsets.all(16.0),

    alignment: Alignment.center,
    child: Text(
      'The Watchman\'s Gazette',
      style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
    ),
  );
}
