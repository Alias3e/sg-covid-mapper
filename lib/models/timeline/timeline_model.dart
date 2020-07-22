import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sgcovidmapper/models/timeline/date_timeline_tile_model.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_tile_model.dart';
import 'package:sgcovidmapper/models/timeline/timeline_tile_model.dart';

class TimelineModel extends Equatable {
  final List<LocationTimelineTileModel> locationTiles;

  TimelineModel(this.locationTiles);

  List<TimelineTileModel> get allTiles {
    List<TimelineTileModel> allModels = [];
    DateFormat format = DateFormat("dd\nMMM");
    int lastDay = locationTiles[0].startTime.day;
    allModels
        .add(DateTimelineTileModel(format.format(locationTiles[0].startTime)));
    for (LocationTimelineTileModel model in locationTiles) {
      if (model.startTime.day != lastDay) {
        allModels.add(DateTimelineTileModel(format.format(model.startTime)));
        lastDay = model.startTime.day;
      }

      allModels.add(model);
    }

    return allModels;
  }

  @override
  List<Object> get props => [locationTiles];
}
