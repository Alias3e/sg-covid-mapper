import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum DividerDirection { right, left, across }

class DividerTimelineItem extends TimelineItem {
  final DividerDirection direction;

  DividerTimelineItem({@required this.direction});

  TimelineDivider get divider {
//    return direction == DividerDirection.left
//        ? const TimelineDivider(
//            thickness: 4,
//            begin: 0.15,
//            end: 0.5,
//          )
//        : const TimelineDivider(
//            thickness: 4,
//            begin: 0.5,
//            end: 0.85,
//          );
    switch (direction) {
      case DividerDirection.right:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.5,
          end: 0.85,
        );
        break;
      case DividerDirection.left:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.15,
          end: 0.5,
        );
        break;
      case DividerDirection.across:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.15,
          end: 0.85,
        );
        break;
    }
  }

  @override
  List<Object> get props => [direction];
}
