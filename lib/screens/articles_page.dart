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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Image
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

          //Text Contents
          Expanded(
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
                      article.publishedAt,
                      style: TextStyle(
                        fontFamily: 'Metropolis',
                        fontWeight: FontWeight.w300,
                        fontSize: 10,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
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
    WidgetsBinding.instance.addPostFrameCallback((duration) {
      _loadMoreNews();
    });
  }

  void _loadMoreNews() async {
    if (_loadingNews) {
      return;
    }
    setState(() {
      _loadingNews = true;
    });
    await NewsApiRequester.getNewsBatch(
      search: _searchFilter?.search,
      selectedSDGs: _searchFilter == null
          ? List.filled(17, true)
          : _searchFilter!.sdgFilters,
      onReceived: (message, result) {
        setState(() {
          for (var newsItem in result) {
            _news.putIfAbsent(int.parse(newsItem.id), () => newsItem);
          }
          _loadingNews = false;
        });
      },
      onFinish: () {
        debugPrint("done loading");
        setState(() {
          _loadingNews = false;
        });
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
                  return SearchScreen(existingFilter: _searchFilter);
                },
              ),
            );
            if (!context.mounted) return;
            if (result is SearchFilter?) {
              WidgetsBinding.instance.addPostFrameCallback((duration) {
                setState(() {
                  _news.clear();
                });
                setState(() {
                  _searchFilter = result;
                  _loadMoreNews();
                });
              });
            }
          },
          icon: Icon(Icons.search),
        ),
      ],
    );
  }

  Widget _buildLoadingBody() {
    return Center(child: CircularProgressIndicator(color: AppColors.primary));
  }

  Widget _buildNoResultsBody() {
    return Center(child: Text("No Results"));
  }

  Widget _buildBodyWidget() {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          _news.clear();
        });
        _loadMoreNews();
      },
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8,
        ),
        itemCount: _news.length,
        itemBuilder: (context, index) {
          return NewsGridItem(article: _news.values.elementAt(index));
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
        padding: const EdgeInsets.all(16.0),
        child: NotificationListener<OverscrollIndicatorNotification>(
          onNotification: (scroll) {
            if (_scrollController.position.userScrollDirection == .forward) {
              return false;
            }
            _loadMoreNews();
            return true;
          },
          child: _buildBody(),
        ),
      ),
    );
  }
}
