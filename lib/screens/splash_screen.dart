import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: Colors.teal,
          child: Center(
              child: Text(
            'SG\nCovid\nMapper',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Monofett',
              color: Colors.amber,
              fontSize: 75,
            ),
          )),
        ),
      ),
    );
  }
}
