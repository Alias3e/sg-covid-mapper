import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';

class PlacesPanel extends StatelessWidget {
  final List<PlaceMarker> markers;

  final ScrollController scrollController;

  const PlacesPanel({@required this.markers, @required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.separated(
        scrollDirection: Axis.vertical,
        controller: scrollController,
        itemCount: markers.length + 2,
        itemBuilder: (context, index) {
          if (index == 0)
            return SizedBox(
              height: 12.0,
            );

          if (index == 1) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                  ),
                ],
              ),
            );
          } else {
            PlaceMarker marker = markers[index - 2];
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
          }
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
    );
  }
}
