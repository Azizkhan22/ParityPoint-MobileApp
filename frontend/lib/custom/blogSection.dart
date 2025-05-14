import 'package:flutter/material.dart';
import './blogCard.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Featured Blogs',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(255, 255, 255, 0.85),
          ),
        ),
        SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: NewsCard(),
              ),
              SizedBox(width: 18),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: NewsCard(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
