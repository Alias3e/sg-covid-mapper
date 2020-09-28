import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class SharedAxisPageRoute extends PageRouteBuilder {
  SharedAxisPageRoute(
      {@required Widget page, SharedAxisTransitionType transitionType})
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
            return SharedAxisTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              transitionType: transitionType,
              child: child,
            );
          },
        );
}
