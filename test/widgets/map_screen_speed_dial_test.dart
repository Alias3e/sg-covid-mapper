import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/widgets/map_screen_speed_dial.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

main() {
  group('Map screen speed dial', () {
    MapBloc bloc;

    setUp(() {
      bloc = MockMapBloc();
    });

    tearDown(() {
      bloc.close();
    });
    testWidgets(
      'Display spinner when MapState is GpsLocationAcquiring',
      (WidgetTester tester) async {
        when(bloc.state).thenAnswer((_) => GpsLocationAcquiring([]));
        await tester.pumpWidget(
          BlocProvider<MapBloc>(
            create: (BuildContext context) => bloc,
            child: Directionality(
              textDirection: TextDirection.ltr,
              child: MapScreenSpeedDial(),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(SpinKitDualRing), findsOneWidget);
        expect(find.byType(AnimatedIcon), findsNothing);
      },
    );

    testWidgets(
        'Displayed animated menu close icon when MapState is GPSLocationUpdated',
        (WidgetTester tester) async {
      List<PlaceMarker> markers = [];
      when(bloc.state).thenAnswer((_) => GpsLocationUpdated(
            currentGpsPosition: LatLng(1.2, 103.0),
            visitedPlaces: markers,
            gpsMarker: Marker(),
          ));
      await tester.pumpWidget(
        BlocProvider<MapBloc>(
          create: (BuildContext context) => bloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MapScreenSpeedDial(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SpinKitDualRing), findsNothing);
      expect(find.byType(AnimatedIcon), findsOneWidget);
    });

    testWidgets(
        'Displayed animated menu close icon when MapState is GPSLocationUpdated',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => GpsLocationFailed([]));
      await tester.pumpWidget(
        BlocProvider<MapBloc>(
          create: (BuildContext context) => bloc,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: MapScreenSpeedDial(),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SpinKitDualRing), findsNothing);
      expect(find.byType(AnimatedIcon), findsOneWidget);
    });
  });
}
