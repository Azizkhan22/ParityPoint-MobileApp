import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './news_provider.dart';

class NewsDetailPage extends StatelessWidget {
  final int articleId;
  const NewsDetailPage({super.key, required this.articleId});

  @override
  Widget build(BuildContext context) {
    final article =
        Provider.of<NewsProvider>(context, listen: false).articles[articleId];
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.network(
              article['cover_image'] ??
                  'https://i.postimg.cc/zVn2MjpZ/imageholder.jpg',
              fit: BoxFit.cover,
              height: 200,
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  margin: EdgeInsets.only(top: 180),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(12, 12, 12, 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          for (var tag in article['tag_list'])
                            if (tag != 'tags') ...[
                              Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 4,
                                  horizontal: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Color.fromRGBO(255, 209, 26, 1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  tag.toString(),
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        '${article['title']}',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• 5 minutes read time',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(126, 126, 129, 1),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              article['user']['profile_image'],
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            '${article['author']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(126, 126, 129, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        article['content'],
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // AppBar icons (optional)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Icon(Icons.bookmark_border, color: Colors.white),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
