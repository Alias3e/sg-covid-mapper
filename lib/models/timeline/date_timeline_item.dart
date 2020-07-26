import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/widgets/timeline/date_indicator.dart';

class DateTimelineItem extends IndicatorTimelineItem {
  final String dateString;

  DateTimelineItem(this.dateString) : super(lineX: 0.5);

  @override
  List<Object> get props => [dateString];

  Widget get indicator => DateIndicator(
        text: dateString,
      );
}
