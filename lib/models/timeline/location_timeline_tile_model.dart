import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/timeline/timeline_tile_model.dart';

enum TimelineType { covid, visit }

class LocationTimelineTileModel extends TimelineTileModel {
  DateTime startTime;
  DateTime endTime;
  String title;
  String subtitle;
  TimelineType type;

  LocationTimelineTileModel(
      {@required this.startTime,
      @required this.endTime,
      @required this.title,
      @required this.subtitle,
      @required this.type});
}
