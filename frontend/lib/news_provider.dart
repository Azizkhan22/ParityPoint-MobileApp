import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsProvider with ChangeNotifier {
  List<Map<String, dynamic>> _articles = [];
  bool _isLoading = true;

  List<Map<String, dynamic>> get articles => _articles;
  bool get isLoading => _isLoading;

  Future<void> fetchArticles({String tag = 'flutter'}) async {
    final url = Uri.parse('https://dev.to/api/articles?tag=$tag&per_page=10');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        _articles = List<Map<String, dynamic>>.from(json.decode(response.body));
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
