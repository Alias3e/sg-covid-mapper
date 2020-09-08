import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/splash_dialog.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isForward = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<InitializationBloc>(context).add(BeginInitialization());
    Future.delayed(Duration(milliseconds: 0))
        .then((value) => _switchAnimation());
  }

  void _switchAnimation() {
    setState(() {
      isForward = !isForward;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitializationBloc, InitializationState>(
      listener: (ctx, state) async {
        Map<String, dynamic> content = {};
        if (state is InitializationComplete) {
          if (state.showDisclaimer) {
            content = state.dialogContent;
            await showSplashDialog(state.dialogContent, 0);
          }
          Navigator.pushNamed(context, '/map');
        }

//        if (state is DialogContentChange)
//          await showSplashDialog(content, state.nextIndex);
      },
      child: Scaffold(
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

  Future<void> showSplashDialog(Map<String, dynamic> dialogContent, int index) {
    return showGeneralDialog(
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 500),
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
