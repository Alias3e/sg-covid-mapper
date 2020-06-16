import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';

class PlaceDetailsWidget extends StatelessWidget {
  final List<PlaceMarker> markers;
  final PersistentBottomSheetController bottomSheetController;

  const PlaceDetailsWidget(
      {@required this.markers, @required this.bottomSheetController});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: makeDetailsColumn(),
    );
  }

  List<Widget> makeDetailsColumn() {
    List<Widget> widgets = [];
    PlaceMarker marker = markers[0];
    widgets.add(
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () => bottomSheetController.close(),
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 4.0),
                width: double.infinity,
                child: const Center(
                  child: const FaIcon(
                    FontAwesomeIcons.angleDoubleDown,
                    color: Colors.teal,
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: Text(
                marker.title,
                style: Styles.kTitleTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
    widgets.add(SizedBox(height: 16.0));

    for (PlaceMarker currentMarker in markers) {
      if (marker.subLocation.isNotEmpty) {
        widgets.add(
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Text(
              currentMarker.subLocation,
              key: Keys.kKeySubLocationText,
              style: Styles.kDetailsTextStyle,
            ),
          ),
        );
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
          child: Text(
            '${Styles.kStartDateFormat.format(currentMarker.startDate.toDate())} - ${Styles.kEndTimeFormat.format(currentMarker.endDate.toDate())}',
            style: Styles.kDetailsTextStyle,
          ),
        ),
      );
    }

    return widgets;
  }
}
