import 'package:flutter/material.dart';

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

  bool _isPasswordVisible = false;
  bool _registerIsPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _registerEmailController.dispose();
    _registerPasswordController.dispose();
    _registerConfirmPasswordController.dispose();
    super.dispose();
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
                          color: Color.fromRGBO(255, 255, 255, 0.8),
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
                      labelText: 'Password',
                      labelStyle: const TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 0.8),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
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
                      // Add login logic here
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
                          color: Color.fromRGBO(255, 255, 255, 0.8),
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
                          color: Color.fromRGBO(255, 255, 255, 0.8),
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
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromRGBO(255, 255, 255, 0.8),
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
                      // Add login logic here
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
                    child: const Text('Alreadty have an account? Login'),
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
