import 'package:flutter/material.dart';

class ReuseableCard extends StatelessWidget {
  ReuseableCard({this.cardChild});

  final Widget cardChild;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPress,
      child: Container(
        child: cardChild,
        // margin: EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            Color(0xFFFA9E85),
            Color(0xFFff8581),
            Color(0xFFfd5a7f)
          ]),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
