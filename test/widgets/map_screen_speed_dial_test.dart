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
        when(bloc.state).thenAnswer(
            (_) => GpsLocationAcquiring(covidPlaces: [], nearbyPlaces: []));
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
      List<PlaceMarker> covidMarkers = [];
      List<Marker> nearbyMarkers = [];

      when(bloc.state).thenAnswer((_) => MapViewBoundsChanged(
            mapCenter: LatLng(1.2, 103.0),
            nearbyPlaces: nearbyMarkers,
            covidPlaces: covidMarkers,
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
      when(bloc.state).thenAnswer(
          (_) => GpsLocationFailed(covidPlaces: [], nearbyPlaces: []));
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
