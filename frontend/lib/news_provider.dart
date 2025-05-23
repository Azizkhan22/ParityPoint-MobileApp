import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> fetchArticles() async {
    final url = Uri.parse('https://dev.to/api/articles?tag=technology&top=200');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _articles =
            data
                .where(
                  (article) =>
                      article['reading_time_minutes'] != null &&
                      article['reading_time_minutes'] > 10,
                )
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
