import 'package:flutter/material.dart';

class Security extends StatefulWidget {
  @override
  _SecurityState createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          Container(
            height: 120.0,
            // color: Theme.of(context).primaryColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFA236FE),
                  blurRadius: 30.0,
                ),
              ],
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color(0xFFA236FE),
                  // Color(0xFF201F32),
                  Color(0xFF6B00FE),
                  Color(0xFFDD00FD)
                ],
              ),
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(top: 25.0),
            child: Text(
              'Security Settings',
              style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Container(
              // padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Text('Under Construction!!'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
