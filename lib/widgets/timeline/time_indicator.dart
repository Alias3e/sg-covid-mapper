import 'package:flutter/material.dart';

class TimeIndicator extends StatelessWidget {
  final String text;

  const TimeIndicator({this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
          color: Colors.teal,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w900, color: Colors.white, fontSize: 11),
        ),
      ),
    );
  }
}
