import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:frontend/service_locator.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  const CustomBottomNavigationBar({super.key});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  final appState = getIt<AppState>();
  @override
  void initState() {
    super.initState();
    appState.setBottomBarIndex(0);
  }

  // Custom widget builder for each item
  Widget _buildNavItem(IconData iconData, String label, int index) {
    final color =
        index == appState.bottomBarIndex
            ? Color.fromRGBO(255, 209, 26, 1)
            : Color.fromRGBO(126, 126, 129, 1);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FaIcon(iconData, color: color, size: 16),
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
                    appState.setBottomBarIndex(0);
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.house, "Home", 0),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    appState.setBottomBarIndex(1);
                  });
                },
                child: _buildNavItem(FontAwesomeIcons.newspaper, "News", 1),
              ),
              GestureDetector(
                onTap: () {
                  appState.setBottomBarIndex(2);
                },
                child: _buildNavItem(FontAwesomeIcons.penNib, "Blog", 2),
              ),
              GestureDetector(
                onTap: () {
                  appState.setBottomBarIndex(3);
                },
                child: _buildNavItem(
                  FontAwesomeIcons.fileLines,
                  "Resources",
                  3,
                ),
              ),
              GestureDetector(
                onTap: () {
                  appState.setBottomBarIndex(4);
                },
                child: _buildNavItem(FontAwesomeIcons.question, "Ask", 4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  int bottomBarIndex = 0;

  void setBottomBarIndex(int index) {
    bottomBarIndex = index;
    notifyListeners();
  }
}
