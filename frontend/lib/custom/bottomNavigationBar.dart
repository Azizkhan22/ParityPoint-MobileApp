import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int bottom_bar_index = 1;
  // Custom widget builder for each item
  Widget _buildNavItem(IconData iconData, String label, int index) {
    final color = index == bottom_bar_index ? Color.fromRGBO(255, 209, 26, 1) : Color.fromRGBO(126, 126, 129, 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(iconData, color: color, size: 16), // Adjust the size here
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(26, 26, 26, 1), 
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(top: 8, bottom: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 8),
          // Icon Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 1;
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.house, "Home", 1),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 2;
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.newspaper, "News", 2),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 3;
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.penNib, "Blog", 3),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 4;
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.fileLines, "Resources", 4),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 5;
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.question, "Ask", 5),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
