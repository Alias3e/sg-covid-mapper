import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';

abstract class TimelineEvent extends Equatable {}

class HasTimelineData extends TimelineEvent {
  final List<ChildTimelineItem> timelineItems;

  HasTimelineData(this.timelineItems);

  @override
  List<Object> get props => [timelineItems];
}
