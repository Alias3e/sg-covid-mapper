import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/widgets/log/empty_log_widget.dart';
import 'package:sgcovidmapper/widgets/log/log.dart';

class LogScreen extends StatelessWidget {
  final dynamic hiveKey;

  const LogScreen({this.hiveKey});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Theme.of(context).primaryColorDark,
      appBar: AppBar(
        title: Text('My Visits Log'),
      ),
      body: Hive.box<Visit>(InitializationBloc.visitBoxName).length > 0
          ? Stack(
              children: [
                LogVisitsList(
                  hiveKey: hiveKey,
                ),
                LogScreenSlidingUpPanel(),
              ],
            )
          : EmptyLogWidget(),
    );
  }
}
