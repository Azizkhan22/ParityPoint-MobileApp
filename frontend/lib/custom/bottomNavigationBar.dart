import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int bottom_bar_index = 1;
  // Custom widget builder for each item
  Widget _buildNavItem(IconData icon, String label, int index) {
    final color = index == bottom_bar_index ? Colors.blue : Colors.grey;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color),
        Text(label, style: TextStyle(color: color, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFF1A1A1A), // dark background
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
                child: _buildNavItem(Icons.home, "Home", 1),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 2;
                  });
                },
                child: _buildNavItem(Icons.home, "Home", 2),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 3;
                  });
                },
                child: _buildNavItem(Icons.home, "Home", 3),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    bottom_bar_index = 4;
                  });
                },
                child: _buildNavItem(Icons.home, "Home", 4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
