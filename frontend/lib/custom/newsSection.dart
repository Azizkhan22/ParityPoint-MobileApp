import 'package:flutter/material.dart';
import './newsCard.dart';
import '../news_provider.dart';
import 'package:provider/provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:frontend/webview.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  String cleanAuthorname(String? input) {
    input ??= 'ParityPoint';
    int commaIndex = input.indexOf(',');
    if (commaIndex != -1) {
      return input.substring(0, commaIndex);
    }
    return input;
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
        Consumer<NewsProvider>(
          builder: (context, provider, child) {
            return provider.isLoading
                ? Container(
                  constraints: BoxConstraints(minHeight: 100, minWidth: 100),
                  alignment: Alignment.center,
                  child: SpinKitThreeBounce(
                    color: Color.fromRGBO(255, 209, 26, 1),
                    size: 30,
                  ),
                )
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children:
                          provider.articles.take(10).map((article) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ArticleWebView(
                                          url: article['url'],
                                          title: "News Article",
                                        ),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 9.0,
                                ),
                                child: SizedBox(
                                  width: 260, // Fixed width for each card
                                  child: NewsCard(
                                    date: (article['publishedAt'] as String)
                                        .substring(0, 9),
                                    author: cleanAuthorname(article['author']),
                                    title: article['title'],
                                    shortDescription:
                                        '${article['content']}...',
                                    imageUrl: article['urlToImage'],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                );
          },
        ),
      ],
    );
  }
}
