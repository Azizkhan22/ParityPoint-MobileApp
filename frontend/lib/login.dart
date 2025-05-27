import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:ui';
import 'user_state.dart';

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  int _currentIndex = 0;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _registerEmailController = TextEditingController();
  final _registerPasswordController = TextEditingController();
  final _registerConfirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _passwordError;
  String? _wrongCredentials;
  bool _isPasswordVisible = false;
  bool _registerIsPasswordVisible = false;
  bool _loginPressed = false;
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
  }

  void showBlurredModal(String? message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.3),
      builder: (BuildContext context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(color: Colors.black.withOpacity(0)),
            ),
            Center(
              child: Container(
                width: 300,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "New Message",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      message ?? "Something went wrong. Please try again.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                        setState(() {
                          _currentIndex = 0;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );
      final responseData = json.decode(response.body);

      if (response.statusCode == 400) {
        setState(() {
          _wrongCredentials = responseData['error'] as String;
        });
        print("User not found");
      } else if (response.statusCode == 201) {
        dynamic token = responseData['token'];
        final userdata = responseData['userData'];
        print(userdata);
        Provider.of<UserState>(context, listen: false).setUser(
          User(
            id: userdata['_id'],
            name: userdata['name'],
            email: userdata['email'],
            imageURL: userdata['image'],
            followers: userdata['followers'],
            following: userdata['following'],
          ),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        throw Exception('Login failed');
      }
    } catch (e) {
      // Handle network or other errors
      print('Error: $e');
    } finally {
      setState(() {
        _loginPressed = false;
      });
    }
  }

  Future<void> _register() async {
    if (_registerPasswordController.text !=
        _registerConfirmPasswordController.text) {
      setState(() {
        _passwordError = 'Passwords do not match';
      });
      print("Passwords do not match");
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': _nameController.text,
          'email': _registerEmailController.text,
          'password': _registerPasswordController.text,
        }),
      );
      final responseData = json.decode(response.body);
      final message = responseData['message'] ?? responseData['error'] ?? '';

      if (response.statusCode == 201) {
        setState(() {
          _nameController.clear();
          _registerEmailController.clear();
          _registerPasswordController.clear();
          _registerConfirmPasswordController.clear();
          _passwordError = null;
          _nameController.clear();
          _registerEmailController.clear();
          _registerPasswordController.clear();
          _registerConfirmPasswordController.clear();
          _passwordError = null;
        });
        showBlurredModal(message);
      } else if (response.statusCode == 400) {
        showBlurredModal(message);
        print("Email already exists");
      } else if (response.statusCode == 500) {
        showBlurredModal(message);
        print("$message");
      } else {
        throw Exception('Registration failed');
      }
    } catch (e) {
      showBlurredModal(e as String);
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          color: Color.fromRGBO(12, 12, 12, 1),
          child: IndexedStack(
            index: _currentIndex,
            children: [
              // Login View
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 60, height: 60),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      errorText: _wrongCredentials,
                      errorStyle: TextStyle(color: Colors.red),
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _loginPressed = true;
                      });
                      _login();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromRGBO(255, 209, 26, 1),
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                    child:
                        _loginPressed
                            ? CircularProgressIndicator()
                            : Text(
                              'Login',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.grey),
                    ),
                    child: const Text('Don\'t have an account? Register'),
                  ),
                ],
              ),
              // Registration View
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo.png', width: 60, height: 60),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _nameController,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _registerEmailController,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _registerPasswordController,
                    obscureText: !_registerIsPasswordVisible,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _registerIsPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                          size: 20,
                        ),
                        onPressed: () {
                          setState(() {
                            _registerIsPasswordVisible =
                                !_registerIsPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _registerConfirmPasswordController,
                    obscureText: !_registerIsPasswordVisible,
                    style: const TextStyle(
                      color: Color.fromRGBO(255, 255, 255, 0.8),
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      errorText: _passwordError,
                      errorStyle: TextStyle(color: Colors.red[300]),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.3),
                        ),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      _register();
                    },
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.all(
                        Color.fromRGBO(255, 209, 26, 1),
                      ),
                      foregroundColor: WidgetStateProperty.all(Colors.black),
                      padding: WidgetStateProperty.all(
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                    ),
                    child: Text(
                      'Register',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                    },
                    style: ButtonStyle(
                      foregroundColor: WidgetStateProperty.all(Colors.grey),
                    ),
                    child: const Text('Already have an account? Login'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
