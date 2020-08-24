import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/widgets/log/log_visit_tile.dart';

class LogVisitsList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
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
    );
  }
}
