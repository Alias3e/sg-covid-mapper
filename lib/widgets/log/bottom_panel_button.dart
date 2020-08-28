import 'package:flutter/material.dart';

class BottomPanelButton extends StatelessWidget {
  final String text;
  final Function onTap;
  final Color color;
  const BottomPanelButton({
    @required this.onTap,
    @required this.color,
    @required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: color, fontSize: 24),
      ),
    );
  }
}
