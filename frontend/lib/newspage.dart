import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/custom/bottomNavigationBar.dart';
import 'package:frontend/service_locator.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  Color appBarColor = Colors.transparent;
  final appState = getIt<AppState>();

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      final offset = _scrollController.offset;

      // You can adjust this threshold
      if (offset > 80 && !_isScrolled) {
        setState(() {
          _isScrolled = true;
          appBarColor = const Color.fromRGBO(20, 20, 20, 1); // Dark solid
        });
      } else if (offset <= 80 && _isScrolled) {
        setState(() {
          _isScrolled = false;
          appBarColor = Colors.transparent; // Back to transparent
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(bottom: 80),
            color: Color.fromRGBO(12, 12, 12, 1),
          ),
        ),
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              flexibleSpace: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                  color: appBarColor,
                  boxShadow: [
                    if (_isScrolled)
                      BoxShadow(
                        color: Color.fromRGBO(26, 26, 26, 1),
                        offset: Offset(0, 4),
                        blurRadius: 8,
                      ),
                  ],
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(8),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Color.fromRGBO(43, 43, 43, 0.4),
                  ),
                  child: IconButton(
                    onPressed:
                        () => appState.setBottomBarIndex(
                          appState.bottomBarIndex - 1,
                        ),
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(12, 12, 12, 1)),
                padding: EdgeInsets.only(bottom: 80),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Discover',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 255, 255, 0.85),
                            ),
                          ),
                          Text(
                            'Read about the topics that interests you',
                            textAlign: TextAlign.start,
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
              ),
            ),
          ],
        ),
      ],
    );
  }
}
