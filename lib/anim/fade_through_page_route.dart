import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class FadeThroughPageRoute extends PageRouteBuilder {
  FadeThroughPageRoute({@required Widget page})
      : super(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation primaryAnimation,
            Animation secondaryAnimation,
            Widget child,
          ) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
        );
}
