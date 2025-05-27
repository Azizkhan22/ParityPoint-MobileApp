import 'package:flutter/material.dart';

class BlogSnippet extends StatelessWidget {
  final String timeAgo;
  final String readTime;
  final String title;
  final String authorName;
  final String? authorImageUrl;
  final bool isSaved;

  const BlogSnippet({
    Key? key,
    required this.timeAgo,
    required this.readTime,
    required this.title,
    required this.authorName,
    this.authorImageUrl,
    this.isSaved = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                image: const DecorationImage(
                  image: AssetImage('assets/images/logo.png'),
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
                                ? NetworkImage(authorImageUrl!)
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
