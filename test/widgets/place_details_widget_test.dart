import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/bottom_panels/bottom_panels.dart';

main() {
  group('Place details widget', () {
    testWidgets('Display single title no sub-location marker details correctly',
        (WidgetTester tester) async {
      Timestamp start = Timestamp.now();
      Timestamp end =
          Timestamp.fromDate(start.toDate().add(Duration(hours: 1)));
      List<PlaceMarker> markers = [
        PlaceMarker(
            subtitle: '',
            title: 'Toa Payoh',
            startTime: start,
            endTime: end,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: PlacesPanel(
                markers: markers,
                scrollController: null,
              ),
            ),
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
            subtitle: 'NTUC',
            title: 'Toa Payoh',
            startTime: start,
            endTime: end,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: PlacesPanel(
                markers: markers,
                scrollController: null,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('Toa Payoh\nNTUC'), findsOneWidget);
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
            subtitle: 'NTUC',
            title: 'Toa Payoh',
            startTime: startOne,
            endTime: endOne,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
        PlaceMarker(
            subtitle: 'Giant',
            title: 'Toa Payoh',
            startTime: startTwo,
            endTime: endTwo,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
        PlaceMarker(
            subtitle: 'Sheng Siong',
            title: 'Toa Payoh',
            startTime: startThree,
            endTime: endThree,
            builder: (context) {
              return Container();
            },
            point: LatLng(1.0, 103.0)),
      ];
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Directionality(
              textDirection: TextDirection.ltr,
              child: PlacesPanel(
                markers: markers,
                scrollController: null,
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(3));
      expect(find.text('Toa Payoh\nNTUC'), findsOneWidget);
      expect(find.text('Toa Payoh\nGiant'), findsOneWidget);
      expect(find.text('Toa Payoh\nSheng Siong'), findsOneWidget);

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
