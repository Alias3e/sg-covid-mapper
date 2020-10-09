import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';

class PlacesPanel extends StatelessWidget {
  final List<PlaceMarker> markers;

  final ScrollController scrollController;

  const PlacesPanel({@required this.markers, @required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.symmetric(vertical: 12),
          width: 30,
          height: 5,
          decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
        ),
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: Expanded(
            child: ListView.separated(
              scrollDirection: Axis.vertical,
              controller: scrollController,
              itemCount: markers.length,
              itemBuilder: (context, index) {
                PlaceMarker marker = markers[index];
                return ListTile(
                  title: Text(
                    marker.subtitle.isEmpty
                        ? marker.title
                        : '${marker.title}\n${marker.subtitle}',
                    style: Styles.kTitleTextStyle,
                  ),
                  subtitle: Text(
                    '${Styles.kStartDateFormat.format(marker.startTime.toDate())} - ${Styles.kEndTimeFormat.format(marker.endTime.toDate())}',
                    style: Styles.kDetailsTextStyle,
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) => index > 1
                  ? Divider(
                      color: Colors.black12,
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
            ),
          ),
        ),
      ],
    );
  }
}
