import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization_bloc.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/widgets/log_visit_tile.dart';

class LogScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Visits Log'),
        ),
        body: ValueListenableBuilder(
          valueListenable:
              Hive.box<Visit>(InitializationBloc.visitBoxName).listenable(),
          builder: (context, box, child) {
            List<Visit> visits = box.values.toList();
            return ListView.builder(
              itemCount: visits.length,
              itemBuilder: (context, index) {
                return LogVisitTile(
                  visit: visits[index],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
