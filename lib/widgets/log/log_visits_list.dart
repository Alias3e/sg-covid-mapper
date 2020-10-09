import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sgcovidmapper/blocs/initialization/initialization.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/widgets/log/log_visit_tile.dart';

class LogVisitsList extends StatefulWidget {
  final dynamic hiveKey;

  const LogVisitsList({this.hiveKey});

  @override
  _LogVisitsListState createState() => _LogVisitsListState();
}

class _LogVisitsListState extends State<LogVisitsList> {
  ItemScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ItemScrollController();
    super.initState();
  }

  void scrollToNewEntry(int index) {
    Future.delayed(Duration(milliseconds: 1000));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.scrollTo(
          index: index, duration: Duration(milliseconds: 500));
    });
  }

  @override
  Widget build(BuildContext context) {
    int selected = -1;
    return ValueListenableBuilder(
      valueListenable:
          Hive.box<Visit>(InitializationBloc.visitBoxName).listenable(),
      builder: (context, box, child) {
        List<Visit> visits = box.values.toList();
        visits.sort(
          (Visit a, Visit b) {
            if (a.checkInTime.isBefore(b.checkInTime))
              return -1;
            else if (a.checkInTime.isAfter(b.checkInTime))
              return 1;
            else {
              if (a.checkOutTime == null) return 1;
              if (b.checkOutTime == null) return -1;

              if (a.checkOutTime.isBefore(b.checkOutTime))
                return -1;
              else
                return 1;
            }
          },
        );
        for (int i = 0; i < visits.length; i++) {
          if (visits[i].key == widget.hiveKey) {
            selected = i;
            scrollToNewEntry(i);
          }
        }
        return ScrollablePositionedList.builder(
          itemScrollController: _scrollController,
          itemCount: visits.length,
          itemBuilder: (context, index) {
            return LogVisitTile(
              visit: visits[index],
              isNew: selected == index,
            );
          },
        );
      },
    );
  }
}
