import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/articles_page.dart';
import 'package:watchmans_gazette/screens/user_profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curFragment = 0;

  Widget _buildNavBar() {
    return NavigationBar(
      selectedIndex: _curFragment,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.bookmarks), label: "Bookmarks"),
        NavigationDestination(
          icon: Icon(Icons.account_circle),
          label: "Account",
        ),
      ],
      onDestinationSelected: (index) {
        setState(() {
          _curFragment = index;
        });
      },
    );
  }

  Widget _buildHome() {
    return ArticlesPage();
  }

  Widget _buildBookmarks() {
    return ArticlesPage();
  }

  Widget _buildProfile() {
    return UserProfilePage();
  }

  Widget _buildBody() {
    switch (_curFragment) {
      case 0:
        return _buildHome();
      case 1:
        return _buildBookmarks();
      case 2:
        return _buildProfile();
      default:
        return _buildHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildNavBar(),
      body: _buildBody(),
    );
  }
}
