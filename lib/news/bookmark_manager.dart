// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';

class BookmarkManager {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  static const COLLECTION_NAME = "bookmarks";

  static Future<void> addBookmark({
    required NewsItem newsItem,
    required Function(BookmarkItem) onSuccess,
    Function(String)? onFail,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (onFail != null) {
        onFail("user is not logged in yet");
      }
      return;
    }

    int curPos = 0;
    final query = await db
        .collection(COLLECTION_NAME)
        .doc(user.uid)
        .collection(COLLECTION_NAME)
        .get();

    curPos = query.size;

    db
        .collection(COLLECTION_NAME)
        .doc(user.uid)
        .collection(COLLECTION_NAME)
        .add({
          "dateAdded": DateTime.now(),
          "pos": curPos,
          "news": {
            "id": newsItem.id,
            "title": newsItem.title,
            "description": newsItem.description,
            "language": newsItem.language,
            "publishedAt": newsItem.publishedAt,
            "source": newsItem.source,
            "site": newsItem.site,
            "category": newsItem.category,
            "country": newsItem.country,
            "author": newsItem.author,
            "keywords": newsItem.keywords,
            "newsImage": {
              "img": newsItem.newsImage.img,
              "video": newsItem.newsImage.video,
            },
            "contentApi": newsItem.contentApi,
            "sdgNumber": newsItem.sdgNumber,
          },
        })
        .then((value) {
          final bookmark = BookmarkItem(
            uuid: value.id,
            dateAdded: DateTime.now(),
            pos: curPos,
            newsItem: newsItem,
          );

          onSuccess(bookmark);
        })
        .catchError((error) {
          if (onFail != null) {
            onFail("$error");
          }
        });
  }

  static Future<void> deleteBookmark({
    required BookmarkItem bookmark,
    required Function(String) onSuccess,
    Function(String)? onFail,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (onFail != null) {
        onFail("user is not logged in yet");
      }
      return;
    }

    db
        .collection(COLLECTION_NAME)
        .doc(user.uid)
        .collection(COLLECTION_NAME)
        .doc(bookmark.uuid)
        .delete()
        .then(
          (value) {
            onSuccess("bookmark deleted");
          },
          onError: (error) {
            if (onFail != null) {
              onFail("$error");
            }
          },
        );
  }

  static Future<void> getBookmarks({
    required Function(List<BookmarkItem>) onSuccess,
    Function(String)? onFail,
  }) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      if (onFail != null) {
        onFail("user is not logged in yet");
      }
      return;
    }

    final QuerySnapshot<Map<String, dynamic>> query;
    try {
      query = await db
          .collection(COLLECTION_NAME)
          .doc(user.uid)
          .collection(COLLECTION_NAME)
          .get();
    } catch (e) {
      if (onFail != null) {
        onFail("$e");
      }
      return;
    }

    final docs = query.docs;
    List<BookmarkItem> bookmarks = List.generate(docs.length, (index) {
      final doc = docs.elementAt(index);
      final newsImage = NewsImage(
        img: doc.get(FieldPath(["news", "newsImage", "img"])),
        video: doc.get(FieldPath(["news", "newsImage", "video"])),
      );
      final newsItem = NewsItem(
        id: doc.get(FieldPath(["news" ,"id"])),
        title: doc.get(FieldPath(["news" ,"title"])),
        description: doc.get(FieldPath(["news" ,"description"])),
        language: doc.get(FieldPath(["news" ,"language"])),
        publishedAt: doc.get(FieldPath(["news" ,"publishedAt"])),
        source: doc.get(FieldPath(["news" ,"source"])),
        site: doc.get(FieldPath(["news" ,"site"])),
        category: doc.get(FieldPath(["news" ,"category"])),
        country: doc.get(FieldPath(["news" ,"country"])),
        author: doc.get(FieldPath(["news" ,"author"])),
        keywords: [],
        contentApi: doc.get(FieldPath(["news" ,"contentApi"])),
        newsImage: newsImage,
        sdgNumber: doc.get(FieldPath(["news" ,"sdgNumber"])),
      );
      return BookmarkItem(
        uuid: doc.id,
        dateAdded: (doc.get("dateAdded") as Timestamp).toDate(),
        pos: doc.get("pos"),
        newsItem: newsItem,
      );
    });
    bookmarks.sort((a, b) => a.pos - b.pos);

    onSuccess(bookmarks);
  }
}

class BookmarkItem {
  String uuid;
  DateTime dateAdded;
  int pos;
  NewsItem newsItem;

  BookmarkItem({
    required this.uuid,
    required this.dateAdded,
    required this.pos,
    required this.newsItem,
  });
}
