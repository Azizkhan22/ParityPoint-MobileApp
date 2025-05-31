import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'webview.dart';
import 'service_locator.dart';
import 'custom/bottomNavigationBar.dart';

class ResourcesPage extends StatelessWidget {
  ResourcesPage({Key? key}) : super(key: key);
  Color appBarColor = Colors.transparent;
  final appState = getIt<AppState>();

  void _navigateToResource(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleWebView(url: url, title: 'Resource'),
      ),
    );
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
          slivers: [
            SliverAppBar(
              pinned: true,
              elevation: 0,
              backgroundColor: Color.fromRGBO(12, 12, 12, 1),
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
                padding: const EdgeInsets.only(
                  top: 16.0,
                  left: 16,
                  right: 16,
                  bottom: 90,
                ),
                color: Color.fromRGBO(12, 12, 12, 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Learning Resources',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(255, 255, 255, 0.85),
                      ),
                    ),
                    SizedBox(height: 20),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: [
                        _buildResourceCard(
                          context,
                          'Frontend',
                          FontAwesomeIcons.html5,
                          Color.fromRGBO(66, 153, 225, 1),
                          'https://frontendmasters.com',
                        ),
                        _buildResourceCard(
                          context,
                          'Backend',
                          FontAwesomeIcons.server,
                          Color.fromRGBO(72, 187, 120, 1),
                          'https://nodejs.org/learn',
                        ),
                        _buildResourceCard(
                          context,
                          'DevOps',
                          FontAwesomeIcons.docker,
                          Color.fromRGBO(237, 100, 166, 1),
                          'https://www.docker.com/get-started',
                        ),
                        _buildResourceCard(
                          context,
                          'Database',
                          FontAwesomeIcons.database,
                          Color.fromRGBO(159, 122, 234, 1),
                          'https://www.mongodb.com/learn',
                        ),
                        _buildResourceCard(
                          context,
                          'Flutter',
                          FontAwesomeIcons.mobile,
                          Color.fromRGBO(246, 173, 85, 1),
                          'https://flutter.dev/docs',
                        ),
                        _buildResourceCard(
                          context,
                          'React',
                          FontAwesomeIcons.react,
                          Color.fromRGBO(99, 179, 237, 1),
                          'https://react.dev',
                        ),
                        _buildResourceCard(
                          context,
                          'Python',
                          FontAwesomeIcons.python,
                          Color.fromRGBO(72, 187, 120, 1),
                          'https://www.python.org/doc',
                        ),
                        _buildResourceCard(
                          context,
                          'JavaScript',
                          FontAwesomeIcons.js,
                          Color.fromRGBO(246, 173, 85, 1),
                          'https://javascript.info',
                        ),
                        _buildResourceCard(
                          context,
                          'UI/UX',
                          FontAwesomeIcons.penRuler,
                          Color.fromRGBO(237, 100, 166, 1),
                          'https://www.figma.com/community/education',
                        ),
                        _buildResourceCard(
                          context,
                          'Git',
                          FontAwesomeIcons.git,
                          Color.fromRGBO(237, 137, 54, 1),
                          'https://git-scm.com/doc',
                        ),
                        _buildResourceCard(
                          context,
                          'Security',
                          FontAwesomeIcons.shieldHalved,
                          Color.fromRGBO(159, 122, 234, 1),
                          'https://www.hacksplaining.com',
                        ),
                        _buildResourceCard(
                          context,
                          'APIs',
                          FontAwesomeIcons.plug,
                          Color.fromRGBO(66, 153, 225, 1),
                          'https://swagger.io/docs',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildResourceCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    String url,
  ) {
    return GestureDetector(
      onTap: () => _navigateToResource(context, url),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromRGBO(8, 8, 8, 1),
              Color.fromRGBO(12, 12, 12, 1),
              Color.fromRGBO(26, 26, 26, 1),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 4),
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 40),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: Color.fromRGBO(255, 255, 255, 0.85),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
