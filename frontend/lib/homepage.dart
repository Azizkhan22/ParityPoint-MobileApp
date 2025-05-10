import 'package:flutter/material.dart';
import 'custom/bottomNavigationBar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(20, 20, 20, 1),
        leading: Container(
          alignment: Alignment.center,
          child: CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/images/profilepic.jpg'),
          ),
        ),

        centerTitle: true,
        title: Image.asset('assets/images/logo.png', height: 40),
        actionsIconTheme: IconThemeData(
          color: Color.fromRGBO(126, 126, 129, 1),
        ),
        actions: [
          IconButton(
            onPressed: () => print('pressed'),
            icon: Icon(Icons.notifications),
          ),
          IconButton(onPressed: () => print('pressed'), icon: Icon(Icons.menu)),
        ],
      ),
      body: Container(color: Color.fromRGBO(20, 20, 20, 1)),
      bottomNavigationBar: CustomBottomNavigationBar(),
    );
  }
}
