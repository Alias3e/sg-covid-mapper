import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:sgcovidmapper/models/timeline/divider_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';

class TimelineModel extends Equatable {
  final List<TimelineItem> tiles;

  TimelineModel({@required this.tiles});

  factory TimelineModel.fromLocation(List<ChildTimelineItem> locations) {
    locations.sort((ChildTimelineItem a, ChildTimelineItem b) {
      if (a.startTime.isBefore(b.startTime))
        return -1;
      else if (a.startTime.isAfter(b.startTime))
        return 1;
      else {
        if (a.endTime == null) return 1;
        if (b.endTime == null) return -1;

        if (a.endTime.isBefore(b.endTime))
          return -1;
        else
          return 1;
      }
    });
    List<TimelineItem> allTiles = [];
    DateFormat format = DateFormat("dd MMM");
    int lastDay;

    for (int i = 0; i < locations.length; i++) {
      if (i == 0) {
        allTiles.add(DateTimelineItem(format.format(locations[i].startTime)));
        _addDivider(allTiles, locations[i]);
        lastDay = locations[0].startTime.day;
      } else {
        if (locations[i].startTime.day != lastDay) {
          _addDivider(allTiles, locations[i - 1]);
          allTiles.add(DateTimelineItem(format.format(locations[i].startTime)));
          _addDivider(allTiles, locations[i]);

          lastDay = locations[i].startTime.day;
        } else {
          if (locations[i] is ChildTimelineItem &&
              locations[i - 1] is ChildTimelineItem) {
            if (locations[i].runtimeType != locations[i - 1].runtimeType)
              allTiles
                  .add(DividerTimelineItem(direction: DividerDirection.across));
          }
        }
      }

      allTiles.add(locations[i]);
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
