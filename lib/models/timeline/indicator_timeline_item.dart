import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';

abstract class ChildTimelineItem extends TimelineItem {
  final DateTime startTime;
  final DateTime endTime;

  ChildTimelineItem({
    @required this.startTime,
    @required this.endTime,
    @required lineX,
  }) : super(lineX: lineX);

  Widget get child;
}
