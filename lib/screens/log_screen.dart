import 'package:flutter/material.dart';
import 'package:sgcovidmapper/widgets/log/log.dart';

class LogScreen extends StatelessWidget {
  final dynamic hiveKey;

  const LogScreen({this.hiveKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text('My Visits Log'),
      ),
      body: Stack(
        children: [
          LogVisitsList(
            hiveKey: hiveKey,
          ),
          LogScreenSlidingUpPanel(),
        ],
      ),
    );
  }
}
