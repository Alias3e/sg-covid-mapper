import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/place_details_widget.dart';

main() {
  group('Place details widget', () {
    testWidgets('Display single title no sub-location marker details correctly',
        (WidgetTester tester) async {
      Timestamp start = Timestamp.now();
      Timestamp end =
          Timestamp.fromDate(start.toDate().add(Duration(hours: 1)));
      List<PlaceMarker> markers = [
        PlaceMarker(
            subLocation: '',
            title: 'Toa Payoh',
            startDate: start,
            endDate: end,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: PlaceDetailsWidget(
            markers: markers,
            bottomSheetController: null,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Toa Payoh'), findsOneWidget);
      expect(find.byKey(Keys.kKeySubLocationText), findsNothing);
      expect(
          find.text(
              '${Styles.kStartDateFormat.format(start.toDate())} - ${Styles.kEndTimeFormat.format(end.toDate())}'),
          findsOneWidget);
    });

    testWidgets(
        'Display single title single sub-location marker details correctly',
        (WidgetTester tester) async {
      Timestamp start = Timestamp.now();
      Timestamp end =
          Timestamp.fromDate(start.toDate().add(Duration(hours: 1)));
      List<PlaceMarker> markers = [
        PlaceMarker(
            subLocation: 'NTUC',
            title: 'Toa Payoh',
            startDate: start,
            endDate: end,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: PlaceDetailsWidget(
            markers: markers,
            bottomSheetController: null,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Toa Payoh'), findsOneWidget);
      expect(find.byKey(Keys.kKeySubLocationText), findsOneWidget);
      expect(
          find.text(
              '${Styles.kStartDateFormat.format(start.toDate())} - ${Styles.kEndTimeFormat.format(end.toDate())}'),
          findsOneWidget);
    });

    testWidgets(
        'Display single title multiple sub-location marker details correctly',
        (WidgetTester tester) async {
      Timestamp startOne = Timestamp.now();
      Timestamp endOne =
          Timestamp.fromDate(startOne.toDate().add(Duration(hours: 1)));
      Timestamp startTwo =
          Timestamp.fromDate(startOne.toDate().add(Duration(hours: 2)));
      Timestamp endTwo =
          Timestamp.fromDate(startOne.toDate().add(Duration(hours: 3)));
      Timestamp startThree =
          Timestamp.fromDate(startOne.toDate().add(Duration(hours: 4)));
      Timestamp endThree =
          Timestamp.fromDate(startOne.toDate().add(Duration(hours: 5)));
      List<PlaceMarker> markers = [
        PlaceMarker(
            subLocation: 'NTUC',
            title: 'Toa Payoh',
            startDate: startOne,
            endDate: endOne,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
        PlaceMarker(
            subLocation: 'Giant',
            title: 'Toa Payoh',
            startDate: startTwo,
            endDate: endTwo,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
        PlaceMarker(
            subLocation: 'Sheng Siong',
            title: 'Toa Payoh',
            startDate: startThree,
            endDate: endThree,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: PlaceDetailsWidget(
            markers: markers,
            bottomSheetController: null,
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Toa Payoh'), findsOneWidget);
      expect(find.byKey(Keys.kKeySubLocationText), findsNWidgets(3));
      expect(
          find.text(
              '${Styles.kStartDateFormat.format(startOne.toDate())} - ${Styles.kEndTimeFormat.format(endOne.toDate())}'),
          findsOneWidget);
      expect(
          find.text(
              '${Styles.kStartDateFormat.format(startTwo.toDate())} - ${Styles.kEndTimeFormat.format(endTwo.toDate())}'),
          findsOneWidget);
      expect(
          find.text(
              '${Styles.kStartDateFormat.format(startThree.toDate())} - ${Styles.kEndTimeFormat.format(endThree.toDate())}'),
          findsOneWidget);
    });
  });
}
