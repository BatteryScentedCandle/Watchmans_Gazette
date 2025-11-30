// ignore_for_file: constant_identifier_names
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:watchmans_gazette/news/sdg_constants.dart';

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

/// # [NewsApiRequester]
/// This class contains tools for retrieving news from fcsapi
///
/// The main utility used in this class is the [getNews] method.
///
/// [SEARCH_IN] is a constant value referring to where to look for the keywords
/// provided by the `find` option. This may be switched between the values of
/// [SearchInValues].
///
/// The [SDG1_KEYWORDS], [SDG2_KEYWORDS], [SDG3_KEYWORDS], etc. are lists of
/// keywords passed into the `find` option of the request. These should be
/// related to the SDG of that number.
///
/// For more info about the API, see the [official docs](https://news.fcsapi.com/documentation/news-api)
///
class NewsApiRequester {
  static const SEARCH_IN = SearchInValues.CONTENT;
  static const NEWS_HOST = "news.fcsapi.com";
  static const REQUEST_ENDPOINT = "/api/news";
  static const NEWS_API_KEY = "NEWS_API_KEY";

  static Uri _getUri({bool https = true, Map<String, dynamic>? params}) {
    return https
        ? Uri.https(NEWS_HOST, REQUEST_ENDPOINT, params)
        : Uri.http(NEWS_HOST, REQUEST_ENDPOINT, params);
  }

  /// # [getNews]
  /// Retrieve news from fcsapi. [sdg] and [onSuccess] are required.
  ///
  /// ## Parameters
  /// The [sdg] refers to the SDG goal number.
  ///
  /// [onSuccess] is a callback for when the request succeeds. The first
  /// parameter is the message of the response. The second is The [NewsResponse]
  /// that contains the retrieved news.
  ///
  /// [onFail] is a callback for when the request fails. The first parameter is
  /// The message of the response.
  ///
  /// [limit] refers to the number of results to request for. Defaults to 20.
  ///
  static Future<void> getNews({
    required int sdg,
    required Function(String, NewsResponse) onSuccess,
    Function(String)? onFail,
    String? search,
    int limit = 20,
  }) async {
    final String apiKey = String.fromEnvironment(NEWS_API_KEY);
    final String keywords = search != null ? "\"$search\"" : _sdgKeywords(sdg);

    Map<String, dynamic> params = {
      ParamKeywords.ACCESS_KEY: apiKey,
      ParamKeywords.FIND: keywords,
      ParamKeywords.LIMIT: limit.toString(),
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
    final news = NewsResponse(
      status: status,
      code: code,
      msg: msg,
      news: newsItems,
    );

    onSuccess(msg, news);
  }

  static List<NewsItem> _extractNews(List<dynamic> news) {
    List<NewsItem> newsItems = .generate(news.length, (index) {
      final map = news[index];
      return _extractNewsItem(map);
    });
    return newsItems;
  }

  static NewsItem _extractNewsItem(Map<String, dynamic> news) {
    NewsImage newsImage = NewsImage(
      img: news["image"]["img"],
      video: news["image"]["video"],
    );
    List<dynamic>? keywords = news["keywords"];
    return NewsItem(
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
      keywords: keywords != null
          ? keywords.cast<String>()
          : [],
      contentApi: news["content_api"],
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

/// # [NewsResponse]
/// Contains the result of the news api request.
///
/// [status] refers to whether the request succeeded or failed.
/// [code] refers to the http status code of the response.
/// [msg] is the message of the response.
/// [news] is a list of news sent by the response.
///
class NewsResponse {
  bool status;
  int code;
  String msg;
  List<NewsItem> news;

  NewsResponse({
    required this.status,
    required this.code,
    required this.msg,
    required this.news,
  });
}

/// # [NewsItem]
/// Contains information about a single news result.
///
/// [id] is the id of the news in fcsapi.
///
/// [source] is the url to the web view of the news.
///
/// [site] refers to the site origin of the news.
///
/// [country] is a comma separated list of country codes.
///
/// [keywords] is a [List] of keywords
///
/// [newsImage] contains either an image or video url of the news. see [NewsImage]
///
/// [contentApi] is the fcsapi url to view the content of the news.
class NewsItem {
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
  String contentApi;

  NewsItem({
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
    required this.contentApi,
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
content_api:
  $contentApi
    ''';
  }
}

/// # [NewsImage]
/// Just contains an [img] or [video] url.
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
