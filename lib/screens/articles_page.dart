import 'package:flutter/material.dart';
//import 'package:https://www.youtube.com/watch?v=x8Srk5Dx5Js' as http;

Future<void> fetchArticles() async{
  var http;
  final response = await http.get('https://whateverthatapiwasthatfetchedthearticles.com');
  if (response.statusCode == 200){
    //get articles
  } else{
    SnackBar(content: Text("Unable to fetch articles. Welcome silence for now. Rest assured, the world is not lost yet"),);
  }
}

class ArticlesPage {
  //const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }
}