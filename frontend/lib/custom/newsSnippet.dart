import 'package:flutter/material.dart';

class NewsSnippet extends StatelessWidget {
  final String? imageUrl;
  final String? title;
  final String? description;
  final String? authorImageUrl;
  final String? authorName;
  final String? date;

  const NewsSnippet({
    super.key,
    this.imageUrl,
    this.title,
    this.description,
    this.authorImageUrl,
    this.authorName,
    this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Color.fromRGBO(12, 12, 12, 1),
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl ?? 'https://i.postimg.cc/zVn2MjpZ/imageholder.jpg',
              width: double.infinity,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Image.network(
                    'https://i.postimg.cc/zVn2MjpZ/imageholder.jpg',
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$title',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$description',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Text(
                      '$authorName',
                      style: TextStyle(
                        color: Color.fromRGBO(126, 126, 129, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$date',
                      style: TextStyle(
                        color: Color.fromRGBO(126, 126, 129, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
