import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_tile_model.dart';

class MyLocationTimelineTileModel extends LocationTimelineTileModel {
  bool isAlert;

  MyLocationTimelineTileModel(
      {@required startTime,
      @required endTime,
      @required title,
      @required subtitle,
      @required type,
      @required this.isAlert})
      : super(
            startTime: startTime,
            endTime: endTime,
            title: title,
            subtitle: subtitle,
            type: type);
}
