import 'package:animations/animations.dart';
import 'package:flutter/material.dart';

class OpenContainerSpeedDial extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Function openBuilder;

  const OpenContainerSpeedDial({this.color, this.icon, this.openBuilder});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: color,
      closedElevation: 6.0,
      closedShape: CircleBorder(),
      closedBuilder: (BuildContext context, void Function() action) {
        return SizedBox(
          child: Center(
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.onSecondary,
            ),
          ),
        );
      },
      openBuilder: openBuilder,
    );
  }
}
