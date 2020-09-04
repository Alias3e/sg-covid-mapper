import 'package:flutter/material.dart';

class ShowcaseContainer extends StatelessWidget {
  final Widget child;
  final double height;
  final double width;

  const ShowcaseContainer({
    @required this.child,
    @required this.height,
    @required this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: EdgeInsets.all(8),
      width: width,
      child: child,
    );
  }
}
