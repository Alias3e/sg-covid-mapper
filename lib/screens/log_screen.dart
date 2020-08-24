import 'package:flutter/material.dart';
import 'package:sgcovidmapper/widgets/log/log.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.tealAccent,
        appBar: AppBar(
          title: Text('My Visits Log'),
        ),
        body: LogScreenSlidingUpPanel(body: LogVisitsList()),
      ),
    );
  }
}
