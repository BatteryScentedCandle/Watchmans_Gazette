import 'package:flutter/material.dart';
import 'package:watchmans_gazette/date/date_formatter.dart';
import 'package:watchmans_gazette/news/bookmark_manager.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';
import 'package:watchmans_gazette/screens/content_view_page.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<StatefulWidget> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<BookmarkItem>? _bookmarks;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  void _loadBookmarks() async {
    await BookmarkManager.getBookmarks(
      onSuccess: (bookmarks) {
        setState(() {
          _bookmarks = bookmarks;
        });
      },
      onFail: (message) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Widget _buildBookmarkLandscape(int index) {
    NewsItem newsItem = _bookmarks![index].newsItem;
    return Dismissible(
      key: Key(newsItem.id),
      direction: .horizontal,
      onDismissed: (direction) {
        _removeBookmark(index);
      },
      child: GestureDetector(
        onTapUp: (details) async {
          await NewsApiRequester.getNewsContent(
            newsItem: _bookmarks![index].newsItem,
            onSuccess: (message, result) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ContentViewPage(newsContent: result.content);
                  },
                ),
              );
            },
            onFail: (message) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: .zero),
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Container(
                      width: .infinity,
                      color: Colors.grey[300],
                      child: Image.network(
                        newsItem.newsImage.img,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.article, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Container(
                      color: Color(0xFFF8EDEA),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsItem.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                newsItem.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontFamily: 'Metropolis',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormatter.formatReadable(
                                DateTime.parse(newsItem.publishedAt),
                              ),
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: .topLeft,
                child: IconButton.filled(
                  style: ButtonStyle(
                    elevation: .all(2),
                    shadowColor: .all(Colors.black),
                    foregroundColor: .all(Colors.black),
                    backgroundColor: .all(Colors.white),
                  ),
                  highlightColor: Colors.black12,
                  onPressed: () => _removeBookmark(index),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookmarkPortrait(int index) {
    if (_bookmarks == null) {
      return Container();
    }
    NewsItem newsItem = _bookmarks![index].newsItem;
    return Dismissible(
      key: Key(newsItem.id),
      direction: .horizontal,
      onDismissed: (direction) {
        _removeBookmark(index);
      },
      child: GestureDetector(
        onTapUp: (details) async {
          await NewsApiRequester.getNewsContent(
            newsItem: _bookmarks![index].newsItem,
            onSuccess: (message, result) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return ContentViewPage(newsContent: result.content);
                  },
                ),
              );
            },
            onFail: (message) {
              ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(SnackBar(content: Text(message)));
            },
          );
        },
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: .zero),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    flex: 6,
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: Image.network(
                        newsItem.newsImage.img,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.article, color: Colors.grey);
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      color: Color(0xFFF8EDEA),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsItem.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              DateFormatter.formatReadable(
                                DateTime.parse(newsItem.publishedAt),
                              ),
                              style: TextStyle(
                                fontFamily: 'Metropolis',
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Align(
                alignment: .topRight,
                child: IconButton.filled(
                  style: ButtonStyle(
                    elevation: .all(2),
                    shadowColor: .all(Colors.black),
                    foregroundColor: .all(Colors.black),
                    backgroundColor: .all(Colors.white),
                  ),
                  highlightColor: Colors.black12,
                  onPressed: () => _removeBookmark(index),
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _removeBookmark(int index) {
    if (_bookmarks == null) {
      return;
    }
    BookmarkManager.deleteBookmark(
      bookmark: _bookmarks![index],
      onSuccess: (message) {
        _loadBookmarks();
      },
      onFail: (message) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  Widget _buildBookmark(int index) {
    if (_bookmarks == null) {
      return Container();
    }
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == .portrait
            ? _buildBookmarkPortrait(index)
            : _buildBookmarkLandscape(index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bookmarks")),
      body: Padding(
        padding: .all(15),
        child: OrientationBuilder(
          builder: (context, orientation) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: orientation == .portrait ? 2 : 1,
                childAspectRatio: orientation == .portrait ? 0.8 : 4,
              ),
              itemCount: _bookmarks?.length ?? 0,
              itemBuilder: (context, index) {
                return _buildBookmark(index);
              },
            );
          },
        ),
      ),
    );
  }
}
