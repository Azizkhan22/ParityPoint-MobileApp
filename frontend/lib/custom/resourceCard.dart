import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ResourceCard extends StatelessWidget {
  const ResourceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(color: Colors.black, offset: Offset(4, 8), blurRadius: 8),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromRGBO(8, 8, 8, 1),
            Color.fromRGBO(12, 12, 12, 1),
            Color.fromRGBO(26, 26, 26, 1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Web Development',
            style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 0.85),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Icon(FontAwesomeIcons.globe, color: Colors.blueAccent),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Explore',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.65),
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
              SizedBox(width: 17),
              Icon(
                FontAwesomeIcons.arrowRight,
                size: 16,
                color: Color.fromRGBO(255, 255, 255, 0.65),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
