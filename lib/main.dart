import 'package:flutter/material.dart';
import 'package:private_call/screens/contact_screen.dart';
import 'package:private_call/screens/favorite_screen.dart';
import 'package:private_call/screens/security_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF201F32),
        scaffoldBackgroundColor: Color(0xFF151522),
      ),
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedTab = 0;
  final _pageOptions = [
    Favorite(),
    ContactPage(),
    Security(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pageOptions[_selectedTab],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        currentIndex: _selectedTab,
        onTap: (int index) {
          setState(() {
            _selectedTab = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            title: Text('Favorite'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            title: Text('Add'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.security),
            title: Text('Security Setting'),
          ),
        ],
      ),
    );
  }
}
