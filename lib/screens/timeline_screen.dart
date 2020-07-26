import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/date_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/divider_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatelessWidget {
  final TimelineModel timelineModel;

  const TimelineScreen({this.timelineModel});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: timelineModel.tiles.length,
        itemBuilder: (context, index) {
          TimelineItem model = timelineModel.tiles[index];

          if (model is DividerTimelineItem) {
            return model.divider;
          } else if (model is IndicatorTimelineItem) {
            return TimelineTile(
              alignment: TimelineAlign.manual,
              isFirst: index == 0,
              isLast: index == timelineModel.tiles.length - 1,
              lineX: model.lineX,
              hasIndicator: true,
              indicatorStyle: IndicatorStyle(
                  padding: EdgeInsets.all(6.0),
                  indicator: model.indicator,
                  width: model is DateTimelineItem ? 80 : 50,
                  height: 50),
              rightChild: model is LocationTimelineItem ? model.child : null,
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        },
      ),
    );
  }
}
