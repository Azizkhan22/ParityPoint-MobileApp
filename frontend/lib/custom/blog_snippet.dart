import 'package:flutter/material.dart';

class BlogSnippet extends StatelessWidget {
  final String timeAgo;
  String? readTime;
  final String title;
  final String content;
  final String authorName;
  String? blogImage;
  final String? authorImageUrl;

  BlogSnippet({
    required this.timeAgo,
    required this.title,
    required this.content,
    required this.authorName,
    this.blogImage,
    this.authorImageUrl,
  });

  void _calculateReadTime() {
    const int charsPerWord = 5;
    const int wordsPerMinute = 225;

    int numberOfWords = (content.length / charsPerWord).ceil();
    int minutes = (numberOfWords / wordsPerMinute).ceil();

    readTime = minutes.toString();
  }

  @override
  Widget build(BuildContext context) {
    _calculateReadTime();
    return Card(
      elevation: 2,
      color: Color.fromRGBO(7, 7, 7, 1),
      shadowColor: Colors.black,
      margin: EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(
                    blogImage ?? 'assets/images/imageholder.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$timeAgo • $readTime read',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage:
                            authorImageUrl != null
                                ? AssetImage(authorImageUrl!)
                                : null,
                        child:
                            authorImageUrl == null
                                ? const Icon(Icons.person, size: 16)
                                : null,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        authorName,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
