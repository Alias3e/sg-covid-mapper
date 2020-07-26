import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sgcovidmapper/models/timeline/divider_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';

class TimelineModel extends Equatable {
  final List<TimelineItem> tiles;

  TimelineModel({@required this.tiles});

  factory TimelineModel.fromLocation(List<LocationTimelineItem> covidLocations,
      List<LocationTimelineItem> myLocations) {
    covidLocations
      ..addAll(myLocations)
      ..sort((LocationTimelineItem a, LocationTimelineItem b) {
        if (a.startTime.isBefore(b.startTime))
          return -1;
        else if (a.startTime.isAfter(b.startTime))
          return 1;
        else {
          if (a.endTime.isBefore(b.endTime))
            return -1;
          else
            return 1;
        }
      });
    List<TimelineItem> allTiles = [];
    DateFormat format = DateFormat("dd MMM");
    int lastDay;

    for (int i = 0; i < covidLocations.length; i++) {
      if (i == 0) {
        allTiles
            .add(DateTimelineItem(format.format(covidLocations[i].startTime)));
        _addDivider(allTiles, covidLocations[i]);
        lastDay = covidLocations[0].startTime.day;
      } else {
        if (covidLocations[i].startTime.day != lastDay) {
          _addDivider(allTiles, covidLocations[i - 1]);
          allTiles.add(
              DateTimelineItem(format.format(covidLocations[i].startTime)));
          _addDivider(allTiles, covidLocations[i]);

          lastDay = covidLocations[i].startTime.day;
        } else {
          if (covidLocations[i] is LocationTimelineItem &&
              covidLocations[i - 1] is LocationTimelineItem) {
            if (covidLocations[i].runtimeType !=
                covidLocations[i - 1].runtimeType)
              allTiles
                  .add(DividerTimelineItem(direction: DividerDirection.across));
          }
        }
      }

      allTiles.add(covidLocations[i]);
    }
//
//    for (LocationTimelineItem model in covidLocations) {
//      if (model.startTime.day != lastDay) {
//        allTiles.add(DateTimelineItem(format.format(model.startTime)));
//        model is MyLocationTimelineItem
//            ? allTiles
//                .add(DividerTimelineItem(direction: DividerDirection.right))
//            : allTiles
//                .add(DividerTimelineItem(direction: DividerDirection.left));
//        lastDay = model.startTime.day;
//      }
//      allTiles.add(model);
//      i++;
//    }

    return TimelineModel(tiles: allTiles);
  }

  static void _addDivider(List<TimelineItem> tiles, TimelineItem item) {
    item is VisitTimelineItem
        ? tiles.add(DividerTimelineItem(direction: DividerDirection.right))
        : tiles.add(DividerTimelineItem(direction: DividerDirection.left));
  }

  @override
  List<Object> get props => [tiles];
}
