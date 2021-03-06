import 'package:flutter/material.dart';

class TimeIndicator extends StatelessWidget {
  final String text;

  const TimeIndicator({this.text});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.all(Radius.circular(25)),
      shadowColor: Theme.of(context).primaryColor,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
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
      ),
    );
  }
}
