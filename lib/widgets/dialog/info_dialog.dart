import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.smileBeam,
            color: Theme.of(context).primaryColor,
            size: 50,
          ),
          SizedBox(
            height: 24,
          ),
          Text(
            'No infected person have visited any public places in the past 2 weeks!',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
          ),
          SizedBox(
            height: 24,
          ),
          FlatButton(
            onPressed: () =>
              Navigator.pop(context)
            ,
            child: Text(
              'Great!',
              style:
                  TextStyle(color: Theme.of(context).accentColor, fontSize: 24),
            ),
          )
        ],
      ),
    );
  }
}
