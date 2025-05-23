import 'package:flutter/material.dart';
import './homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'custom/bottomNavigationBar.dart';
import 'service_locator.dart';
import 'newsArticle.dart';

void main() {
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()..fetchArticles()),
        ChangeNotifierProvider.value(value: getIt<AppState>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParityPoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(builder: (context) => HomePage());
        }

        if (settings.name == '/news-article') {
          final articleId = settings.arguments as int?;
          if (articleId == null) {
            return MaterialPageRoute(
              builder:
                  (_) =>
                      Scaffold(body: Center(child: Text('Missing article ID'))),
            );
          }
          return MaterialPageRoute(
            builder: (_) => NewsDetailPage(articleId: articleId),
          );
        }

        // Optional fallback
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(child: Text('Unknown route: ${settings.name}')),
              ),
        );
      },
    );
  }
}
