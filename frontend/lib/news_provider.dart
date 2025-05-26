import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class NewsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = false;
  final String? _apiKey = dotenv.env['NEWSAPIKEY'];
  List<Map<String, dynamic>> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> fetchArticles() async {
    _isLoading = true;
    final now = DateTime.now();
    final oneWeekAgo = now.subtract(Duration(days: 7));
    final fromDate = oneWeekAgo.toIso8601String().substring(0, 10);
    final toDate = now.toIso8601String().substring(0, 10);
    final url = Uri.parse(
      'https://newsapi.org/v2/everything?q=software%20development&from=$fromDate&to=$toDate&sortBy=publishedAt&apiKey=$_apiKey',
    );
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final articlesList = data['articles'] as List;
        _articles =
            articlesList
                .map<Map<String, dynamic>>(
                  (article) => Map<String, dynamic>.from(article),
                )
                .toList();
      } else {
        throw Exception('Failed to load articles');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
