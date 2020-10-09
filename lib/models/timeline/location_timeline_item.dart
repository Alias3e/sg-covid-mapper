import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/timeline/location_body.dart';
import 'package:sgcovidmapper/widgets/timeline/time_indicator.dart';
import 'package:sgcovidmapper/widgets/timeline/timeline_indicator.dart';

class LocationTimelineItem extends ChildTimelineItem with TimelineIndicator {
  final String title;
  final String subtitle;

  LocationTimelineItem(
      {@required startTime,
      @required endTime,
      @required this.title,
      @required this.subtitle,
      @required lineX})
      : super(lineX: lineX, startTime: startTime, endTime: endTime);

  @override
  List<Object> get props => [startTime, endTime, title, subtitle];

  @override
  Widget get child => LocationBody(
        item: this,
      );

  @override
  Widget get indicator => TimeIndicator(
        text:
            '${Styles.kEndTimeFormat.format(startTime)}\n${Styles.kEndTimeFormat.format(endTime)}',
      );

  factory LocationTimelineItem.fromFirestoreSnapshot(
      DocumentSnapshot snapshot) {
    Timestamp startTimestamp = snapshot.data()['start_time'];
    Timestamp endTimestamp = snapshot.data()['end_time'];

    return LocationTimelineItem(
      startTime: startTimestamp.toDate(),
      endTime: endTimestamp.toDate(),
      title: snapshot.data()['title'],
      subtitle: snapshot.data()['subtitle'],
      lineX: 0.15,
    );
  }
}
