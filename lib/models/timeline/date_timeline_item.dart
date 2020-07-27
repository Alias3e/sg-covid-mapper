import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';
import 'package:sgcovidmapper/widgets/timeline/date_indicator.dart';
import 'package:sgcovidmapper/widgets/timeline/timeline_indicator.dart';

class DateTimelineItem extends TimelineItem with TimelineIndicator {
  final String dateString;

  DateTimelineItem(this.dateString) : super(lineX: 0.5);

  @override
  List<Object> get props => [dateString];

  @override
  Widget get indicator => DateIndicator(
        text: dateString,
      );
}
