import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/custom/bottomNavigationBar.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  Color appBarColor = Colors.transparent;

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
        CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent, // Make initially transparent
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
                child: IconButton(
                  onPressed: () => print('Hello'),
                  icon: Icon(FontAwesomeIcons.circleChevronLeft),
                ),
              ),
              actionsIconTheme: IconThemeData(
                color: Color.fromRGBO(126, 126, 129, 1),
              ),
              actions: [
                IconButton(
                  onPressed: () => print('pressed'),
                  icon: FaIcon(FontAwesomeIcons.bell, size: 18),
                ),
                IconButton(
                  onPressed: () => print('pressed'),
                  icon: FaIcon(FontAwesomeIcons.bars, size: 18),
                ),
              ],
            ),

            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: Color.fromRGBO(12, 12, 12, 1)),
                padding: EdgeInsets.only(bottom: 80),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    children: [SizedBox(height: 20), SizedBox(height: 20)],
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
