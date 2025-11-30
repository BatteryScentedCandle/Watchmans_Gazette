import 'package:flutter/material.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';
import 'package:watchmans_gazette/news/search_filter.dart';
import 'package:watchmans_gazette/screens/search_screen.dart';
import 'package:watchmans_gazette/theme/app_color.dart';

class NewsGridItem extends StatelessWidget {
  final NewsItem article;

  const NewsGridItem({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 120,
            width: double.infinity,
            color: Colors.grey[300],
            child: Image.network(
              article.newsImage.img,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.article, color: Colors.grey);
              },
            ),
          ),
          Expanded(
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
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Expanded(
                    child: Text(
                      article.description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.publishedAt,
                    style: TextStyle(fontSize: 10, color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ArticlesPage extends StatefulWidget {
  const ArticlesPage({super.key});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  final Map<int, NewsItem> _news = Map.identity();
  final ScrollController _scrollController = ScrollController();
  bool _loadingNews = false;
  SearchFilter? _searchFilter;

  @override
  void initState() {
    super.initState();
    _loadMoreNews();
  }

  void _loadMoreNews() async {
    if (_loadingNews) {
      return;
    }
    _loadingNews = true;
    await NewsApiRequester.getNewsBatch(
      search: _searchFilter?.search,
      selectedSDGs: _searchFilter == null
          ? List.filled(17, true)
          : _searchFilter!.sdgFilters,
      onSuccess: (message, result) {
        setState(() {
          debugPrint("size of news: ${result.length}");
          for (var newsItem in result) {
            _news.putIfAbsent(int.parse(newsItem.id), () => newsItem);
          }
          _loadingNews = false;
        });
      },
      onFail: (message, result) {
        for (var newsItem in result) {
          _news.putIfAbsent(int.parse(newsItem.id), () => newsItem);
        }
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        _loadingNews = false;
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("News Articles"),
      actions: [
        IconButton(
          onPressed: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return SearchScreen();
                },
              ),
            );
            if (result is SearchFilter) {
              setState(() {
                _searchFilter = result;
                _news.clear();
                _loadMoreNews();
              });
            }
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (scroll) {
            if (_scrollController.position.userScrollDirection == .forward) {
              return false;
            }
            _loadMoreNews();
            return true;
          },
          child: _news.isEmpty
              ? Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      _news.clear();
                    });
                    _loadMoreNews();
                  },
                  child: GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                          childAspectRatio: 0.8,
                        ),
                    itemCount: _news.length,
                    itemBuilder: (context, index) {
                      return NewsGridItem(
                        article: _news.values.elementAt(index),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
