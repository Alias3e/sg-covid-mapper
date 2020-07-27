import 'package:flutter/foundation.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/timeline/time_indicator.dart';
import 'package:sgcovidmapper/widgets/timeline/timeline_indicator.dart';
import 'package:sgcovidmapper/widgets/timeline/visit_body.dart';

enum WarningLevel { none, low, high }

class VisitTimelineItem extends ChildTimelineItem with TimelineIndicator {
  final WarningLevel warningLevel;
  final String title;
  final List<String> tags;

  VisitTimelineItem(
      {@required startTime,
      @required endTime,
      @required this.title,
      @required this.tags,
      @required lineX,
      @required this.warningLevel})
      : super(lineX: lineX, startTime: startTime, endTime: endTime);

  @override
  List<Object> get props => [warningLevel, title, tags, startTime, endTime];

  factory VisitTimelineItem.fromHiveVisit(Visit visit) {
    return VisitTimelineItem(
      title: visit.title,
      startTime: visit.checkInTime,
      endTime: visit.checkOutTime,
      lineX: 0.85,
      warningLevel: WarningLevel.none,
      tags: visit.tags,
    );
  }

  @override
  Widget get indicator => TimeIndicator(
      text: endTime != null
          ? '${Styles.kEndTimeFormat.format(startTime)}\n${Styles.kEndTimeFormat.format(endTime)}'
          : '${Styles.kEndTimeFormat.format(startTime)}');

  @override
  Widget get child => VisitBody(
        item: this,
      );
}
