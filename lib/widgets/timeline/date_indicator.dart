import 'package:flutter/material.dart';

class DateIndicator extends StatelessWidget {
  final String text;

  DateIndicator({
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: Colors.blueGrey,
      borderRadius: BorderRadius.all(Radius.circular(18)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.amber,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(18)),
//          border: Border.all(width: 4, color: Colors.blueGrey),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
