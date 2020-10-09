import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/dialog/splash_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isForward = false;
  String messageOfTheDay;
  IconData iconData;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InitializationBloc>(context).add(BeginInitialization());
//    Future.delayed(Duration(milliseconds: 0))
//        .then((value) => _switchAnimation());
    List<String> messages = [
      "Wear a mask when you leave your house",
      "Wash hands frequently with soap or hand sanitizer",
      "Practice safe distancing, keep 1 metre apart.",
      "See a doctor if you have flu-like symptoms",
      "Avoid touching your eyes, nose and mouth",
    ];
    List<IconData> icons = [
      FontAwesomeIcons.headSideMask,
      FontAwesomeIcons.handsWash,
      FontAwesomeIcons.peopleArrows,
      FontAwesomeIcons.userMd,
      FontAwesomeIcons.handshakeAltSlash,
    ];
    int index = Random().nextInt(5);
    messageOfTheDay = messages[index];
    iconData = icons[index];
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializationBloc, InitializationState>(
      listener: (ctx, state) async {
        if (state is InitializationComplete) {
          if (state.showDisclaimer) {
            await showSplashDialog(state.dialogContent, 0);
          }
          Navigator.pushNamed(context, '/map');
        }

//        if (state is DialogContentChange)
//          await showSplashDialog(content, state.nextIndex);
      },
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16),
          color: AppColors.kColorPrimaryLight,
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 64),
              Text(
                'TrackCovid@Sg',
                style: TextStyle(
                    fontFamily: 'FredokaOne',
                    fontSize: 44,
                    color: Theme.of(context).primaryColor),
              ),
              SizedBox(height: 128),
              Icon(
                iconData,
                color: Theme.of(context).primaryColor,
                size: 120,
              ),
              SizedBox(height: 32),
              Text(
                messageOfTheDay,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Theme.of(context).primaryColor, fontSize: 18),
              )
            ],
          ),
//          child: Center(
//            child: AnimatedDefaultTextStyle(
//              curve: Curves.decelerate,
//              onEnd: () => _switchAnimation(),
//              style: isForward
//                  ? TextStyle(
//                      fontFamily: 'FrederickatheGreat',
//                      color: AppColors.kColorPrimary,
//                      fontSize: 100,
//                    )
//                  : TextStyle(
//                      fontFamily: 'FrederickatheGreat',
//                      color: AppColors.kColorPrimary,
//                      fontSize: 75,
//                    ),
//              duration: Duration(milliseconds: 500),
//              child: Text(
//                'SG\nCovid\nMapper',
//                textAlign: TextAlign.center,
//              ),
//            ),
//          ),
        ),
      ),
    );
  }

  Future<void> showSplashDialog(Map<String, dynamic> dialogContent, int index) {
    return showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 400),
      context: context,
      pageBuilder: (_, anim1, anim2) {
        return Align(
            alignment: Alignment.bottomCenter,
            child: SplashDialog(
              dialogContents: dialogContent['dialog'],
            ));
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }
}
