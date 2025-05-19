import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsCard extends StatelessWidget {
  final String? date;
  final String? author;
  final String? title;
  final String? shortDescription;
  final String? imageUrl;

  const NewsCard({
    super.key,
    this.date,
    this.author,
    this.title,
    this.shortDescription,
    this.imageUrl,
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
            width: 250,
            height: 150,
            padding: EdgeInsets.only(top: 15, right: 15, left: 15),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                imageUrl ?? 'assets/images/imageholder.jpg',
                fit: BoxFit.cover,
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
                Text(
                  "$date / BY $author ",
                  style: TextStyle(
                    color: Color.fromRGBO(126, 126, 129, 1),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '$title',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                ),
                SizedBox(height: 5),
                Text(
                  '$shortDescription',
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.65),
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 4,
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
