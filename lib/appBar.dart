import 'package:flutter/material.dart';

class AppbarCustom extends StatelessWidget {
  AppbarCustom({this.tMain});
  final String tMain;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120.0,
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
        tMain,
        style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
