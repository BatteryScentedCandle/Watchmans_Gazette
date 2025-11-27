import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:watchmans_gazette/news/news_api_requester.dart';

void main() {
  test("news api test", () async {
    await NewsApiRequester.getNews(
      sdg: 5,
      onSuccess: (message, result) {
        debugPrint("message: ${result.msg}");
        expect(result.code, 200);
        expect(result.news.length, greaterThan(0));
        for (var news in result.news) {
          debugPrint(news.toString());
        }
      },
      onFail: (message) {
        debugPrint('''
        Yeah, Whoospie daisy
        I just had to hit, it's my duty baby
        ''');
        neverCalled();
      },
    );
  });
}
