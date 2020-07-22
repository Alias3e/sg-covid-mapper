import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';
import 'package:sgcovidmapper/models/timeline/timeline_tile_model.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Timeline extends StatelessWidget {
  final TimelineModel timelineModel;

  const Timeline({this.timelineModel});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: timelineModel.allTiles.length,
      itemBuilder: (context, index) {
        TimelineTileModel model = timelineModel.allTiles[index];

        return TimelineTile(
          alignment: TimelineAlign.manual,
          isFirst: index == 0,
          isLast: index == timelineModel.allTiles.length - 1,
          lineX: 0.25,
//          indicatorStyle: indicator,
//          leftChild: leftChild,
//          rightChild: righChild,
//          hasIndicator: step.isCheckpoint,
//          topLineStyle: LineStyle(
//            color: step.color,
//            width: 8,
//          ),
        );
      },
    );
  }
}
