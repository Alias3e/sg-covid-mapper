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
      borderRadius: BorderRadius.all(Radius.circular(16)),
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).accentColor,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(16)),
//          border: Border.all(width: 4, color: Colors.blueGrey),
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
