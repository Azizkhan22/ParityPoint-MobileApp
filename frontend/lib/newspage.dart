import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/custom/bottomNavigationBar.dart';
import 'package:frontend/service_locator.dart';
import 'package:provider/provider.dart';
import 'custom/newsSnippet.dart';
import './news_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'webview.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  Color appBarColor = Colors.transparent;
  final appState = getIt<AppState>();

  String cleanAuthorname(String? input) {
    input ??= 'ParityPoint';
    int commaIndex = input.indexOf(',');
    if (commaIndex != -1) {
      return input.substring(0, commaIndex);
    } else if (input.length > 18) {
      return input.substring(0, 18);
    }
    return input;
  }

  void openNewsDetail(int articleId) {
    Navigator.pushNamed(context, '/news-article', arguments: articleId);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 80),
            color: Color.fromRGBO(12, 12, 12, 1),
          ),
        ),
        CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(43, 43, 43, 0.4),
                  ),
                  child: IconButton(
                    onPressed:
                        () => appState.setBottomBarIndex(
                          appState.bottomBarIndex - 1,
                        ),
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(12, 12, 12, 1)),
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 80,
                  left: 20,
                  right: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Discover',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 0.85),
                          ),
                        ),
                        Text(
                          'Read about the topics that interests you',
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            color: Color.fromRGBO(126, 126, 129, 1),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      height: 30,
                      margin: EdgeInsets.only(top: 20),
                      child: TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          labelText: 'Search',
                          labelStyle: TextStyle(fontSize: 12),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              width: 1,
                              color: Colors.grey,
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Consumer<NewsProvider>(
                        builder: (context, provider, child) {
                          return provider.isLoading
                              ? Container(
                                constraints: BoxConstraints(
                                  minHeight: 100,
                                  minWidth: 100,
                                ),
                                alignment: Alignment.center,
                                child: SpinKitThreeBounce(
                                  color: Color.fromRGBO(255, 209, 26, 1),
                                  size: 30,
                                ),
                              )
                              : Column(
                                children:
                                    provider.articles.asMap().entries.map((
                                      entry,
                                    ) {
                                      var article = entry.value;
                                      return GestureDetector(
                                        onTap:
                                            () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => ArticleWebView(
                                                      url: article['url'],
                                                    ),
                                              ),
                                            ),
                                        child: NewsSnippet(
                                          imageUrl: article['urlToImage'],
                                          title: article['title'],
                                          description: article['content'],
                                          authorName: cleanAuthorname(
                                            article['author'],
                                          ),
                                          date: (article['publishedAt']
                                                  as String)
                                              .substring(0, 9),
                                        ),
                                      );
                                    }).toList(),
                              );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
