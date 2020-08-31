import 'package:flutter/material.dart';
import 'package:sgcovidmapper/util/constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isForward = false;

  @override
  void initState() {
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => _switchAnimation());
    super.initState();
  }

  void _switchAnimation() {
    setState(() {
      isForward = !isForward;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          color: AppColors.kColorPrimaryLight,
          child: Center(
            child: AnimatedDefaultTextStyle(
              curve: Curves.decelerate,
              onEnd: () => _switchAnimation(),
              style: isForward
                  ? TextStyle(
                      fontFamily: 'FrederickatheGreat',
                      color: AppColors.kColorPrimary,
                      fontSize: 100,
                    )
                  : TextStyle(
                      fontFamily: 'FrederickatheGreat',
                      color: AppColors.kColorPrimary,
                      fontSize: 75,
                    ),
              duration: Duration(milliseconds: 500),
              child: Text(
                'SG\nCovid\nMapper',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
