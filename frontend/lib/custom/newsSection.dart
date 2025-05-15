import 'package:flutter/material.dart';
import './newsCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  @override
  void initState() {
    super.initState();
    fetchData();
    fetchDevToArticles();
  }

  Future<List<dynamic>> fetchDevToArticles() async {
  final url = Uri.parse('https://dev.to/api/articles');  
  final response = await http.get(url);

  if (response.statusCode == 200) {
    print(jsonDecode(response.body));
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load Dev.to articles');
  }
}


  Future<void> fetchData() async {
    await Future.delayed(Duration(seconds: 5));
    setState(() {
      _isLoading = false;
    });
  }

  bool _isLoading = true;
  List<Widget> fetchCards() {
    List<Widget> cards = [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: NewsCard(
          date: '12-4-2025',
          author: 'Syed Khizer',
          title: 'I am a weak Programmer',
        ),
      ),
      SizedBox(width: 18),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: NewsCard(),
      ),
      SizedBox(width: 18),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: NewsCard(),
      ),
      SizedBox(width: 18),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: NewsCard(),
      ),
    ];
    return cards;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'News of the Week',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 0.85),
          ),
        ),
        SizedBox(height: 10),
        _isLoading
            ? Container(
              constraints: BoxConstraints(minHeight: 100, minWidth: 100),
              alignment: Alignment.center,
              child: SpinKitThreeBounce(color: Color.fromRGBO(255, 209, 26, 1), size: 30,),
            )
            : SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: fetchCards()),
            ),
      ],
    );
  }
}
