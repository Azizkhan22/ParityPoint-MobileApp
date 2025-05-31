import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend/service_locator.dart';
import 'custom/bottomNavigationBar.dart';
import 'custom/newsSection.dart';
import 'custom/blogSection.dart';
import 'custom/resourceSection.dart';
import './newspage.dart';
import 'blog_page.dart';
import 'package:provider/provider.dart';
import 'user_state.dart';
import 'resources_page.dart';
import 'custom/app_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final appState = getIt<AppState>();

  final List<Widget> _screens = [
    HomeContent(),
    NewsPage(),
    BlogPage(),
    ResourcesPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      endDrawer: AppDrawer(),
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: appState,
            builder: (context, _) {
              return IndexedStack(
                index: appState.bottomBarIndex,
                children: _screens,
              );
            },
          ),
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

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;
  Color appBarColor = Colors.transparent;
  String? username;
  String? userImage;

  @override
  void initState() {
    super.initState();
    username = Provider.of<UserState>(context, listen: false).user?.name;
    userImage = Provider.of<UserState>(context, listen: false).user?.imageURL;

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
                child: Text(
                  '👋 Hello, $username',
                  textAlign: TextAlign.center,
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                    color: const Color.fromRGBO(255, 255, 255, 0.75),
                    fontWeight: FontWeight.w200,
                    fontSize: 15,
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
              backgroundColor: Colors.transparent,
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
              leading: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/user'),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CircleAvatar(
                    radius: 17,
                    backgroundImage: AssetImage(
                      userImage ?? 'assets/images/avatar.png',
                    ),
                  ),
                ),
              ),

              actionsIconTheme: IconThemeData(
                color: Color.fromRGBO(126, 126, 129, 1),
              ),
              actions: [
                IconButton(
                  onPressed: () => Navigator.pushNamed(context, '/user/search'),
                  icon: FaIcon(FontAwesomeIcons.magnifyingGlass, size: 18),
                ),
                Builder(
                  builder:
                      (context) => IconButton(
                        onPressed: () => Scaffold.of(context).openEndDrawer(),
                        icon: FaIcon(FontAwesomeIcons.bars, size: 18),
                      ),
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
                      SizedBox(height: 20),
                      ResourceSection(),
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
