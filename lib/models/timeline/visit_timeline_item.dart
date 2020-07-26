import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';

class VisitTimelineItem extends LocationTimelineItem {
  final bool isAlert;

  VisitTimelineItem(
      {@required startTime,
      @required endTime,
      @required title,
      @required subtitle,
      @required lineX,
      @required this.isAlert})
      : super(
            startTime: startTime,
            endTime: endTime,
            title: title,
            subtitle: subtitle,
            lineX: lineX);

  @override
  // TODO: implement props
  List<Object> get props => super.props..add(isAlert);
}
