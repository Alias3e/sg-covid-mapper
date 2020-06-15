import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/map_screen_fab.dart';

main() {
  List<PlaceMarker> markers = [];

  group('Map Floating Action Button', () {
    testWidgets('Display spinner when MapState is GPSAcquiring',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MapScreenFAB(
            state: GpsLocationAcquiring(markers),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(Keys.kKeyFABSpinner), findsOneWidget);
      expect(find.byIcon(Icons.gps_fixed), findsNothing);
    });

    testWidgets('Display spinner when MapState is GPSLocationUpdated',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MapScreenFAB(
            state: GpsLocationUpdated(
              currentGpsPosition: LatLng(1.2, 103.0),
              visitedPlaces: markers,
              gpsMarker: Marker(),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(Keys.kKeyFABSpinner), findsNothing);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
    });

    testWidgets('Display spinner when MapState is GPSLocationFailed',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: MapScreenFAB(
            state: GpsLocationFailed(markers),
          ),
        ),
      );

      await tester.pump();
      expect(find.byKey(Keys.kKeyFABSpinner), findsNothing);
      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
    });
  });
}
