import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';

class ContentViewPage extends StatelessWidget {
  final NewsItemContent newsContent;

  const ContentViewPage({super.key, required this.newsContent});

  AppBar _buildAppBar() {
    return AppBar();
  }

  String _getAuthor() {
    if (newsContent.author.isEmpty) {
      return newsContent.site;
    }
    return newsContent.author;
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (rect) {
              return LinearGradient(
                begin: .topCenter,
                end: .bottomCenter,
                colors: [Colors.black, Colors.black, Colors.transparent],
                stops: [0, 0.7, 1],
              ).createShader(rect);
            },
            blendMode: .dstIn,
            child: Image.network(newsContent.newsImage.img),
          ),
          Padding(
            padding: .only(left: 12, right: 12, bottom: 12),
            child: SelectionArea(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    newsContent.title,
                    style: TextStyle(fontSize: 24, fontWeight: .bold),
                  ),
                  Row(
                    crossAxisAlignment: .center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.account_circle, size: 16),
                          SizedBox(width: 4),
                          Text(_getAuthor()),
                        ],
                      ),
                      SizedBox(width: 12),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, size: 16),
                          SizedBox(width: 4),
                          Text(newsContent.publishedAt),
                        ],
                      ),
                    ],
                  ),
                  InkWell(
                    child: Text(
                      "View source...",
                      textAlign: .start,
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                    onTapUp: (details) async {
                      final uri = Uri.parse(newsContent.source);
                      if (!await launchUrl(uri)) {
                        throw Exception("Could not open $uri");
                      }
                    },
                  ),
                  const Padding(padding: .all(5)),
                  Text(
                    newsContent.description,
                    textAlign: .justify,
                    style: TextStyle(fontSize: 16),
                  ),
                  const Padding(padding: .all(5)),
                  Text(
                    newsContent.content,
                    textAlign: .justify,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody());
  }
}
