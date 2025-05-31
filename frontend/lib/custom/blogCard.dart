import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BlogCard extends StatelessWidget {
  final String timeAgo;
  String? readTime;
  final String title;
  final String content;
  final String authorName;
  String? blogImage;
  final String? authorImageUrl;

  BlogCard({
    required this.timeAgo,
    required this.title,
    required this.content,
    required this.authorName,
    this.blogImage,
    this.authorImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 260),
      decoration: BoxDecoration(
        color: Color.fromRGBO(8, 8, 8, 1),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(4, 8), blurRadius: 8),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 220,
            height: 220,
            padding: EdgeInsets.only(top: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                8,
              ), // Optional: rounded corners
              child: Image.asset(
                blogImage ?? 'assets/images/imageholder.jpg',
                fit: BoxFit.cover, // Fills and crops as needed
                width: double.infinity,
                height: double.infinity,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 12,
                      backgroundImage: AssetImage(
                        authorImageUrl ?? 'assets/images/avatar.png',
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      "$authorName . $timeAgo",
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Color.fromRGBO(126, 126, 129, 1),
                        fontSize: 12,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  title,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  content,
                  maxLines: 4,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 30),
                GestureDetector(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Read More',
                        style: TextStyle(
                          color: Color.fromRGBO(126, 126, 129, 1),
                          fontSize: 13,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                      SizedBox(width: 17),
                      Icon(
                        FontAwesomeIcons.circleChevronRight,
                        color: Color.fromRGBO(126, 126, 129, 1),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
