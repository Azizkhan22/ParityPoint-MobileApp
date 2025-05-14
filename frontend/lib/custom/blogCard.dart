import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NewsCard extends StatelessWidget {
  const NewsCard({super.key});

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
              child: Image.network(
                'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1470&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
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
                        'assets/images/profilepic.jpg',
                      ),
                    ),
                    SizedBox(width: 10,),
                    Text(
                      "William Ashford . 5 min read ",
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
                  'data is very important for us and also for programmers',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.85),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Hello my name is aziz ullah khan kakar here today my lecture will be on how to talk to girls properly',
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
