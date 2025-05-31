import 'package:flutter/material.dart';

class BlogDetailPage extends StatelessWidget {
  final String timeAgo;
  String? readTime;
  final String title;
  final String content;
  final String authorName;
  String? blogImage;
  final String? authorImageUrl;

  BlogDetailPage({
    required this.timeAgo,
    required this.title,
    required this.content,
    required this.authorName,
    this.blogImage,
    this.authorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200,
              child: Image(
                image: AssetImage(blogImage ?? 'assets/images/imageholder.jpg'),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print('Error loading blog image: $error');
                  return Image.asset(
                    'assets/images/imageholder.jpg',
                    fit: BoxFit.cover,
                    height: 200,
                  );
                },
              ),
            ),
          ),

          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  constraints: BoxConstraints(minHeight: 600),
                  margin: EdgeInsets.only(top: 180),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(12, 12, 12, 1),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(32),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, -3),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 12),
                      Text(
                        title,
                        style: TextStyle(
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        '• ${readTime ?? '3'} min read • $timeAgo',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(126, 126, 129, 1),
                        ),
                      ),
                      SizedBox(height: 24),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundImage: AssetImage(
                              authorImageUrl ?? 'assets/images/avatar.png',
                            ),
                            radius: 20,
                            onBackgroundImageError: (exception, stackTrace) {
                              print('Error loading author image: $exception');
                            },
                          ),
                          SizedBox(width: 12),
                          Text(
                            authorName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(126, 126, 129, 1),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Text(
                        content,
                        style: TextStyle(
                          fontSize: 13,
                          color: Color.fromRGBO(255, 255, 255, 0.85),
                          height: 1.5,
                        ),
                      ),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Color.fromRGBO(12, 12, 12, 0),
                              Color.fromRGBO(12, 12, 12, 1),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

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
