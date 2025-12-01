import 'package:flutter/material.dart';
import 'package:watchmans_gazette/news/bookmark_manager.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';
import 'package:watchmans_gazette/screens/articles_page.dart';
import 'package:watchmans_gazette/screens/bookmarks_page.dart';
import 'package:watchmans_gazette/screens/user_profile_page.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _curFragment = 0;
  bool _hovered = false;

  final ValueNotifier<bool> _dragNotifier = ValueNotifier(false);

  NavigationDestination _buildBookmarksNav() {
    return NavigationDestination(
      icon: Icon(Icons.bookmarks),
      label: "Bookmarks",
    );
  }

  Widget _buildDragNotifier() {
    return ValueListenableBuilder(
      valueListenable: _dragNotifier,
      builder: (context, value, widget) {
        return AnimatedContainer(
          height: value ? 150 : 0,
          width: value ? 150 : 0,
          alignment: .center,
          duration: Duration(milliseconds: 250),
          curve: Curves.fastOutSlowIn,
          decoration: BoxDecoration(
            color: value ? AppColors.secondary : Colors.transparent,
            borderRadius: .all(.circular(50)),
          ),
        );
      },
    );
  }

  Widget _buildHoverNotifier() {
    return AnimatedContainer(
      height: _hovered ? 150 : 0,
      width: _hovered ? 150 : 0,
      alignment: .center,
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(
        color: _hovered ? AppColors.primary : Colors.transparent,
        borderRadius: .all(.circular(50)),
      ),
    );
  }

  Widget _buildNavBar() {
    return NavigationBar(
      selectedIndex: _curFragment,
      destinations: [
        NavigationDestination(icon: Icon(Icons.home), label: "Home"),
        DragTarget<NewsItem>(
          onAcceptWithDetails: (details) async {
            await BookmarkManager.addBookmark(
              newsItem: details.data,
              onSuccess: (bookmark) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(content: Text("Added to bookmarks!")),
                  );
              },
              onFail: (message) {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(SnackBar(content: Text(message)));
              },
            );
          },
          builder: (context, candidates, rejected) {
            _hovered = candidates.isNotEmpty;
            return Stack(
              children: [
                Center(child: _buildDragNotifier()),
                Center(child: _buildHoverNotifier()),
                _buildBookmarksNav(),
              ],
            );
          },
        ),
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
    return ArticlesPage(dragNotifier: _dragNotifier);
  }

  Widget _buildBookmarks() {
    return BookmarksPage();
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
    return Scaffold(bottomNavigationBar: _buildNavBar(), body: _buildBody());
  }
}
