import 'package:flutter/material.dart';

class CheckPanelButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final IconData icon;
  final Color color;

  const CheckPanelButton(
      {@required this.text,
      @required this.onPressed,
      this.color,
      @required this.icon});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      shape: StadiumBorder(),
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Insert icon and space if it is not null
          this.icon != null
              ? Icon(
                  icon,
                  color: Colors.white,
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
          this.icon != null
              ? SizedBox(width: 8)
              : Container(
                  width: 0,
                  height: 0,
                ),
          Text(
            text,
            style: TextStyle(
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
