import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/models/timeline/timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';
import 'package:sgcovidmapper/widgets/timeline/timeline_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';

class TimelineScreen extends StatelessWidget {
  final TimelineModel timelineModel;

  const TimelineScreen({this.timelineModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (notification) {
          notification.disallowGlow();
          return false;
        },
        child: Container(
          color: Theme.of(context).primaryColorLight,
          child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                title: Text('Timeline'),
                floating: true,
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  // The builder function returns a ListTile with a title that
                  // displays the index of the current item.
                  (context, index) {
                    TimelineItem model = timelineModel.tiles[index];

                    if (model is DividerTimelineItem) {
                      return model.divider;
                    } else if (model is TimelineIndicator) {
                      return TimelineTile(
                        alignment: TimelineAlign.manual,
                        isFirst: index == 0,
                        isLast: index == timelineModel.tiles.length - 1,
                        bottomLineStyle:
                            LineStyle(color: Theme.of(context).primaryColor),
                        topLineStyle:
                            LineStyle(color: Theme.of(context).primaryColor),
                        lineX: model.lineX,
                        hasIndicator: true,
                        indicatorStyle: IndicatorStyle(
                            padding: EdgeInsets.all(6.0),
                            indicator: (model as TimelineIndicator).indicator,
                            width: model is DateTimelineItem ? 70 : 50,
                            height: model is DateTimelineItem ? 40 : 50),
                        rightChild:
                            model is LocationTimelineItem ? model.child : null,
                        leftChild:
                            model is VisitTimelineItem ? model.child : null,
                      );
                    } else {
                      return Container(
                        width: 0,
                        height: 0,
                      );
                    }
                  },
                  childCount: timelineModel.tiles.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
