import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../user_state.dart';
import '../webview.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  bool isLoggingOut = false;

  Future<void> _handleLogout(BuildContext context) async {
    setState(() {
      isLoggingOut = true;
    });

    // Simulate logout delay
    await Future.delayed(Duration(seconds: 2));

    // Clear user state
    Provider.of<UserState>(context, listen: false).clearUser();

    // Pop drawer first
    Navigator.pop(context);

    // Navigate to login
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Color.fromRGBO(18, 18, 18, 1),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[800]),
            ListTile(
              leading: Icon(Icons.person_outline, color: Colors.white),
              title: Text(
                'About Developer',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ArticleWebView(
                          url: 'https://github.com/Azizkhan22',
                          title: 'Developer Profile',
                        ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline, color: Colors.white),
              title: Text('App Info', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add app info action
              },
            ),
            ListTile(
              leading: Icon(Icons.settings_outlined, color: Colors.white),
              title: Text('Settings', style: TextStyle(color: Colors.white)),
              onTap: () {
                // Add settings action
              },
            ),
            Divider(color: Colors.grey[800]),
            Expanded(child: SizedBox()),
            if (isLoggingOut)
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircularProgressIndicator(
                      color: Color.fromRGBO(255, 209, 26, 1),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Logging out...',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              )
            else
              Padding(
                padding: EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: () => _handleLogout(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(255, 209, 26, 1),
                    minimumSize: Size(double.infinity, 45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
