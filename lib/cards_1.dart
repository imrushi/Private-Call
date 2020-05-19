import 'package:flutter/material.dart';
import 'resuable_card.dart';

class CardType extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Text('data'),
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.only(right: 140.0),
      padding: EdgeInsets.only(top: 10.0),
      child: ReuseableCard(
        cardChild: Center(child: Text('Friend')),
      ),
    );
  }

  customColor() {
    return BoxDecoration(
      gradient: LinearGradient(
          colors: [Color(0xFFffd2d1), Color(0xFFff8581), Color(0xFFfd5a7f)]),
    );
  }
}
