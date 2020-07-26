import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';

abstract class IndicatorTimelineItem extends TimelineItem {
  final double lineX;

  IndicatorTimelineItem({@required this.lineX});

  Widget get indicator;
}
