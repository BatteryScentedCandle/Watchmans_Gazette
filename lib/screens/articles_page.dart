import 'dart:async';

import 'package:flutter/material.dart';
import 'package:watchmans_gazette/date/date_formatter.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';
import 'package:watchmans_gazette/news/search_filter.dart';
import 'package:watchmans_gazette/screens/content_view_page.dart';
import 'package:watchmans_gazette/screens/search_screen.dart';
import 'package:watchmans_gazette/theme/app_color.dart';
import 'package:watchmans_gazette/theme/sdg_colors.dart';

class NewsGridItem extends StatelessWidget {
  final ValueNotifier<bool> dragNotifier;
  final NewsItem article;

  const NewsGridItem({
    super.key,
    required this.article,
    required this.dragNotifier,
  });

  Widget _buildLandscapeCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: GestureDetector(
        onTapUp: (details) async {
          await NewsApiRequester.getNewsContent(
            newsItem: article,
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image
            Expanded(flex: 4, child: _ArticleTag()),

            //Text Contents
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
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          article.description,
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
                          DateTime.parse(article.publishedAt),
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
      ),
    );
  }

  Widget _buildPortraitCard(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: GestureDetector(
        onTapUp: (details) async {
          await NewsApiRequester.getNewsContent(
            newsItem: article,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Image
            Expanded(flex: 6, child: _ArticleTag()),

            //Text Contents
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
                        article.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'Metropolis',
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Expanded(
                        child: Text(
                          article.description,
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
                          DateTime.parse(article.publishedAt),
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
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        return orientation == .portrait
            ? _buildPortraitCard(context)
            : _buildLandscapeCard(context);
      },
    );
  }

  Widget _ArticleTag() {
    if(article.sdgNumber == -1){
      return Container();
    }
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          color: Colors.grey[300],
          child: Image.network(
            article.newsImage.img,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.article, color: Colors.grey, size: 40);
            },
          ),
        ),
        if (article.sdgNumber != null &&
            SdgColors.colors.containsKey(article.sdgNumber))
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
              decoration: BoxDecoration(
                color: SdgColors.colors[article.sdgNumber],
                borderRadius: BorderRadius.circular(4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Text(
                'SDG ${article.sdgNumber}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Metropolis',
                  height: 1.0,
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LongPressDraggable<NewsItem>(
      data: article,
      onDragStarted: () => dragNotifier.value = true,
      onDragEnd: (_) => dragNotifier.value = false,
      feedback: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: -15 / 360),
        duration: Duration(milliseconds: 250),
        curve: Curves.easeOut,
        builder: (context, value, child) {
          return RotationTransition(
            turns: AlwaysStoppedAnimation(value),
            child: child,
          );
        },
        child: Opacity(
          opacity: 0.8,
          child: SizedBox(height: 200, width: 160, child: _buildCard(context)),
        ),
      ),

      child: _buildCard(context),
    );
  }
}

class ArticlesPage extends StatefulWidget {
  final ValueNotifier<bool> dragNotifier;
  final ScrollController scrollController;
  const ArticlesPage({
    super.key,
    required this.dragNotifier,
    required this.scrollController,
  });

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with TickerProviderStateMixin {
  final Map<int, NewsItem> _news = Map.identity();
  bool _loadingNews = false;
  SearchFilter? _searchFilter;

  StreamController<List<NewsItem>> _newsStream = StreamController.broadcast();
  int _streamId = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _loadMoreNews();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _newsStream.close();
  }

  void _addNews(List<NewsItem> news) {
    for (var newsItem in news) {
      _news.putIfAbsent(int.parse(newsItem.id), () => newsItem);
    }
  }

  void _loadMoreNews({bool more = false}) async {
    if (_loadingNews) {
      return;
    }
    setState(() {
      _loadingNews = true;
      if (!_newsStream.hasListener) {
        _newsStream.stream.listen(_addNews);
      }
    });
    int key = 0;
    setState(() {
      key = more ? _streamId : ++_streamId;
    });
    await NewsApiRequester.getNewsBatch(
      search: _searchFilter?.search,
      loadedIds: _news.keys.toList(),
      selectedSDGs: _searchFilter == null
          ? List.filled(17, true)
          : _searchFilter!.sdgFilters,
      onReceived: (message, result) {
        if (key != _streamId) {
          return;
        }
        setState(() {
          _newsStream.add(result);
          _loadingNews = false;
        });
      },
      onFinish: () async {
        debugPrint("done loading");
        setState(() {
          _loadingNews = false;
        });
      },
    );
  }

  Future<dynamic> _showSearchScreen() async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return SearchScreen(existingFilter: _searchFilter);
        },
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("News Articles"),
      actions: [
        _searchFilter != null
            ? IconButton(
                onPressed: () {
                  setState(() {
                    _searchFilter = null;
                    _resetNews();
                    _loadMoreNews();
                  });
                },
                icon: Icon(Icons.filter_list_off),
                tooltip: "clear filters",
              )
            : Container(),
        IconButton(
          onPressed: () async {
            final result = await _showSearchScreen();
            if (!context.mounted) return;
            if (result is SearchFilter?) {
              if (result == null) {
                return;
              }
              setState(() {
                _newsStream = StreamController();
                _news.clear();
                _searchFilter = !result.isDefault() ? result : null;
                _loadMoreNews();
              });
            }
          },
          icon: Icon(Icons.search),
          tooltip: "Search",
        ),
      ],
    );
  }

  void _resetNews() {
    _news.clear();
  }

  Widget _buildLoadingBody() {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildNoResultsBody() {
    return Center(child: Text("No Results"));
  }

  Widget _buildBodyWidget() {
    return Expanded(
      child: OrientationBuilder(
        builder: (context, orientation) {
          return GridView.builder(
            controller: widget.scrollController,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: orientation == .portrait ? 2 : 1,
              childAspectRatio: orientation == .portrait ? 0.8 : 4,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: _news.length,
            itemBuilder: (context, index) {
              return NewsGridItem(
                article: _news.values.elementAt(index),
                dragNotifier: widget.dragNotifier,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBody() {
    if (_news.isEmpty) {
      if (_loadingNews) {
        return _buildLoadingBody();
      }
      return _buildNoResultsBody();
    }
    return _buildBodyWidget();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (scroll) {
            if (widget.scrollController.position.userScrollDirection ==
                .forward) {
              return false;
            }
            _loadMoreNews(more: true);
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _resetNews();
              });
              _loadMoreNews();
            },
            child: _buildBody(),
          ),
        ),
      ),
    );
  }
}
