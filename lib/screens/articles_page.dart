import 'package:flutter/material.dart';

class NewsArticle {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt;

  const NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
  });
}

class NewsResponse {
  final List<NewsArticle> news;

  const NewsResponse({required this.news});
}

class NewsGridItem extends StatelessWidget {
  final NewsArticle article;

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
              article.imageUrl,
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
  final List<NewsArticle> articles;

  const ArticlesPage({super.key, required this.articles});

  @override
  State<ArticlesPage> createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('News Articles')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.8,
          ),
          itemCount: widget.articles.length,
          itemBuilder: (context, index) {
            return NewsGridItem(article: widget.articles[index]);
          },
        ),
      ),
    );
  }
}

class NewsService {
  static Future<NewsResponse> getNews({required int sdg}) async {
    return NewsResponse(news: []);
  }
}
