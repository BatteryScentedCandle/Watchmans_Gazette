import 'package:flutter/material.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';

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
  bool _loadingNews = false;

  @override
  void initState() {
    super.initState();
    _loadMoreNews(4);
  }

  void _loadMoreNews(int sdg) async {
    if (_loadingNews) {
      return;
    }
    _loadingNews = true;
    await NewsApiRequester.getNews(
      sdg: sdg,
      limit: 20,
      onSuccess: (message, result) {
        setState(() {
          debugPrint("size of news: ${result.news.length}");
          for (var newsItem in result.news) {
            _news.putIfAbsent(int.parse(newsItem.id), () => newsItem);
          }
          _loadingNews = false;
        });
      },
      onFail: (message) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Articles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NotificationListener<OverscrollNotification>(
          onNotification: (scroll) {
            _loadMoreNews(1);
            return true;
          },
          child: RefreshIndicator(
            onRefresh: () async {
              _loadMoreNews(1);
            },
            child: GridView.builder(
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
          ),
        ),
      ),
    );
  }
}
