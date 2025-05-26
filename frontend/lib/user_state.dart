import 'package:flutter/foundation.dart';

class User {
  final String name;
  final String email;
  String imageURL;
  List<dynamic> followers;
  List<dynamic> following;

  User({
    required this.name,
    required this.email,
    required this.imageURL,
    required this.followers,
    required this.following,
  });
}

class UserState with ChangeNotifier {
  User? _user;

  User? get user => _user;

  bool get isLoggedIn => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  void updateImage(String url) {
    _user?.imageURL = url;
  }

  void clearUser() {
    _user = null;
    notifyListeners();
  }
}
