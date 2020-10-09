import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';
import 'package:timeline_tile/timeline_tile.dart';

enum DividerDirection { right, left, across }

class DividerTimelineItem extends TimelineItem {
  final DividerDirection direction;

  DividerTimelineItem({@required this.direction});

  TimelineDivider get divider {
    switch (direction) {
      case DividerDirection.right:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.5,
          end: 0.85,
          color: Colors.deepPurple,
        );
        break;
      case DividerDirection.left:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.15,
          end: 0.5,
          color: Colors.deepPurple,
        );
        break;
      default:
        return const TimelineDivider(
          thickness: 4,
          begin: 0.15,
          end: 0.85,
          color: Colors.deepPurple,
        );
        break;
    }
  }

  @override
  List<Object> get props => [direction];
}
