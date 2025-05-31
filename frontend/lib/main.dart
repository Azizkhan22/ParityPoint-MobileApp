import 'package:flutter/material.dart';
import './homepage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';
import 'custom/bottomNavigationBar.dart';
import 'service_locator.dart';
import 'splashscreen.dart';
import 'login.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'user_page.dart';
import 'user_state.dart';
import 'search_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(
    fileName: '/home/aziz/repos/ParityPoint-MobileApp/frontend/.env',
  );
  setupLocator();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NewsProvider()..fetchArticles()),
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider.value(value: getIt<AppState>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ParityPoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.interTextTheme()),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/user': (context) => UserPage(),
        '/user/search': (context) => SearchPage(),
      },
    );
  }
}
