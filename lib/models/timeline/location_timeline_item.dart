import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/timeline/location_body.dart';
import 'package:sgcovidmapper/widgets/timeline/time_indicator.dart';

class LocationTimelineItem extends IndicatorTimelineItem {
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String subtitle;

  LocationTimelineItem(
      {@required this.startTime,
      @required this.endTime,
      @required this.title,
      @required this.subtitle,
      @required lineX})
      : super(lineX: lineX);

  @override
  List<Object> get props => [startTime, endTime, title, subtitle];

  Widget get child => LocationBody(
        item: this,
      );

  Widget get indicator => TimeIndicator(
        text:
            '${Styles.kEndTimeFormat.format(startTime)}\n${Styles.kEndTimeFormat.format(endTime)}',
      );

  factory LocationTimelineItem.fromFirestoreSnapshot(
      DocumentSnapshot snapshot) {
    Timestamp startTimestamp = snapshot['start_time'];
    Timestamp endTimestamp = snapshot['end_time'];

    return LocationTimelineItem(
      startTime: startTimestamp.toDate(),
      endTime: endTimestamp.toDate(),
      title: snapshot['title'],
      subtitle: snapshot['subtitle'],
      lineX: 0.15,
    );
  }
}
