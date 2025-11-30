import 'package:flutter/material.dart';
import 'package:watchmans_gazette/screens/articles_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String _appBarTitle = "News Articles";
  int _curFragment = 0;

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(_appBarTitle),
      actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
    );
  }

  Widget _buildNavBar() {
    return NavigationBar(
      selectedIndex: _curFragment,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        NavigationDestination(icon: Icon(Icons.bookmarks), label: "Bookmarks"),
        NavigationDestination(
          icon: Icon(Icons.portrait_outlined),
          label: "Profile",
        ),
      ],
      onDestinationSelected: (index){
        setState(() {
            _curFragment = index;
            switch (_curFragment) {
            case 1:
              _appBarTitle = "Bookmarks";
            case 2:
              _appBarTitle = "Profile";
            case 0:
            default:
              _appBarTitle = "News Articles";
            }
        });
      },
    );
  }

  Widget _buildHome(){
    return ArticlesPage();
  }

  Widget _buildBookmarks(){
    return ArticlesPage();
  }

  Widget _buildProfile(){
    return ArticlesPage();
  }

  Widget _buildBody(){
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
      appBar: _buildAppBar(),
      bottomNavigationBar: _buildNavBar(),
      body: _buildBody(),
    );
  }
}
