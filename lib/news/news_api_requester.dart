// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart' as http;

class ParamKeywords {
  static const ACCESS_KEY = "access_key";
  static const FIND = "find";
  static const LIMIT = "limit";
}

class SearchInValues {
  static const TITLE = "title";
  static const CONTENT = "content";
  static const DESCRIPTION = "description";
}

class NewsApiRequester {
  static const SEARCH_IN = SearchInValues.CONTENT;
  static const NEWS_HOST = "news.fcsapi.com";
  static const REQUEST_ENDPOINT = "/api/news";
  static const NEWS_API_KEY = "NEWS_API_KEY";
  static const SDG1_KEYWORDS = ["poverty", "poor", "homeless"];
  static const SDG2_KEYWORDS = [""];
  static const SDG3_KEYWORDS = [""];
  static const SDG4_KEYWORDS = [""];
  static const SDG5_KEYWORDS = [""];
  static const SDG6_KEYWORDS = [""];
  static const SDG7_KEYWORDS = [""];
  static const SDG8_KEYWORDS = [""];
  static const SDG9_KEYWORDS = [""];
  static const SDG10_KEYWORDS = [""];
  static const SDG11_KEYWORDS = [""];
  static const SDG12_KEYWORDS = [""];
  static const SDG13_KEYWORDS = [""];
  static const SDG14_KEYWORDS = [""];
  static const SDG15_KEYWORDS = [""];
  static const SDG16_KEYWORDS = [""];
  static const SDG17_KEYWORDS = [""];

  static Uri _getUri({bool https = true, Map<String, dynamic>? params}) {
    return https
        ? Uri.https(NEWS_HOST, REQUEST_ENDPOINT, params)
        : Uri.http(NEWS_HOST, REQUEST_ENDPOINT, params);
  }

  static Future<void> getNews({
    required Function(String, ResponseBody) onSuccess,
    Function(String)? onFail,
    required int sdg,
    int limit = 20,
  }) async {
    final String apiKey = String.fromEnvironment(NEWS_API_KEY);
    final String keywords = _sdgKeywords(sdg);

    Map<String, dynamic> params = {
      ParamKeywords.ACCESS_KEY: apiKey,
      ParamKeywords.FIND: keywords,
      // ParamKeywords.LIMIT: limit,
    };

    final Uri uri = _getUri(params: params);

    final response = await http.get(uri);

    if (response.statusCode != 200) {
      if (onFail != null) onFail("something went wrong");
      return;
    }

    Map<String, dynamic> body = jsonDecode(response.body);

    final msg = body["msg"];
    bool status = body["status"];
    final code = body["code"];

    if (!status) {
      if (onFail != null) {
        onFail(msg);
      }
      return;
    }

    final newsItems = _extractNews(body["response"]);
    final news = ResponseBody(
      status: status,
      code: code,
      msg: msg,
      news: newsItems,
    );

    onSuccess(msg, news);
  }

  static List<NewsResponse> _extractNews(List<dynamic> news) {
    List<NewsResponse> newsItems = .generate(news.length, (index) {
      final map = news[index];
      return _extractNewsItem(map);
    });
    return newsItems;
  }

  static NewsResponse _extractNewsItem(Map<String, dynamic> news) {
    NewsImage newsImage = NewsImage(
      img: news["image"]["img"],
      video: news["image"]["video"],
    );
    List<dynamic> keywords = news["keywords"];
    return NewsResponse(
      id: news["id"],
      title: news["title"],
      description: news["description"],
      language: news["language"],
      publishedAt: news["publishedAt"],
      source: news["source"],
      site: news["site"],
      category: news["category"],
      country: news["country"],
      author: news["author"],
      keywords: .generate(keywords.length, (index) => keywords[index]),
      newsImage: newsImage,
    );
  }

  static String _sdgKeywords(int sdg) {
    List<String> keywords;
    switch (sdg) {
      case 1:
        keywords = SDG1_KEYWORDS;
      case 2:
        keywords = SDG2_KEYWORDS;
      case 3:
        keywords = SDG3_KEYWORDS;
      case 4:
        keywords = SDG4_KEYWORDS;
      case 5:
        keywords = SDG5_KEYWORDS;
      case 6:
        keywords = SDG6_KEYWORDS;
      case 7:
        keywords = SDG7_KEYWORDS;
      case 8:
        keywords = SDG8_KEYWORDS;
      case 9:
        keywords = SDG9_KEYWORDS;
      case 10:
        keywords = SDG10_KEYWORDS;
      case 11:
        keywords = SDG11_KEYWORDS;
      case 12:
        keywords = SDG12_KEYWORDS;
      case 13:
        keywords = SDG13_KEYWORDS;
      case 14:
        keywords = SDG14_KEYWORDS;
      case 15:
        keywords = SDG15_KEYWORDS;
      case 16:
        keywords = SDG16_KEYWORDS;
      case 17:
        keywords = SDG17_KEYWORDS;
      default:
        keywords = [];
    }

    return keywords.join(" ");
  }
}

class ResponseBody {
  bool status;
  int code;
  String msg;
  List<NewsResponse> news;

  ResponseBody({
    required this.status,
    required this.code,
    required this.msg,
    required this.news,
  });
}

class NewsResponse {
  String id;
  String title;
  String description;
  String language;
  String publishedAt;
  String source;
  String site;
  String category;
  String country;
  String author;
  List<String> keywords;
  NewsImage newsImage;

  NewsResponse({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.publishedAt,
    required this.source,
    required this.site,
    required this.category,
    required this.country,
    required this.author,
    required this.keywords,
    required this.newsImage,
  });

  @override
  String toString() {
    return '''
id:
  $id
title:
  $title
description:
  $description
language:
  $language
publishedAt:
  $publishedAt
source:
  $source
site:
  $site
category:
  $category
country:
  $country
author:
  $author
keywords:
  $keywords
newsImage:
  $newsImage
    ''';
  }
}

class NewsImage {
  String img;
  String video;

  NewsImage({required this.img, required this.video});

  @override
  String toString() {
    return '''
  img:
    $img
  video:
    $video
    ''';
  }
}
