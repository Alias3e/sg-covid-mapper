import 'package:flutter/material.dart';
import 'package:sgcovidmapper/widgets/log/log.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text('My Visits Log'),
      ),
      body: Stack(
        children: [
          LogVisitsList(),
          LogScreenSlidingUpPanel(),
        ],
      ),
    );
  }
}
