import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'custom/bottomNavigationBar.dart';
import 'custom/newsSection.dart';
import 'custom/blogSection.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Stack(
              children: [
                Hero(
                  tag: 'hero-image',
                  child: Image.asset(
                    'assets/images/hero.jpg',
                    fit: BoxFit.cover,
                    height: 180,
                    width: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 60,
                  left: 10,
                  right: 10,
                  child: Expanded(
                    child: Text(
                      'Empowering Developers to Learn, Share, and Grow Together.',
                      textAlign: TextAlign.center,
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                backgroundColor:
                    Colors.transparent, // Make initially transparent
                centerTitle: true,
                title: Image.asset('assets/images/logo.png', height: 45),
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
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: AssetImage('assets/images/profilepic.jpg'),
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
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(12, 12, 12, 1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  margin: EdgeInsets.only(top: 100),
                  padding: EdgeInsets.only(bottom: 80),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Column(
                      children: [
                        NewsSection(),
                        SizedBox(height: 20),
                        BlogSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Bottom navigation on top of everything
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: CustomBottomNavigationBar(),
          ),
        ],
      ),
    );
  }
}
