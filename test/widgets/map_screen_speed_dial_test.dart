import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/widgets/map/map_screen_speed_dial.dart';

class MockGpsBloc extends MockBloc<GpsEvent, GpsState> implements GpsBloc {}

class MockUpdateOpacityBloc
    extends MockBloc<UpdateOpacityEvent, UpdateOpacityState>
    implements UpdateOpacityBloc {}

class MockReverseGeocodeBloc
    extends MockBloc<ReverseGeocodeEvent, ReverseGeocodeState>
    implements ReverseGeocodeBloc {}

main() {
  group('Map screen speed dial', () {
    GpsBloc gpsBloc;
    UpdateOpacityBloc updateOpacityBloc;
    ReverseGeocodeBloc reverseGeocodeBloc;

    setUp(() {
      gpsBloc = MockGpsBloc();
      updateOpacityBloc = MockUpdateOpacityBloc();
      reverseGeocodeBloc = MockReverseGeocodeBloc();
      when(updateOpacityBloc.state)
          .thenAnswer((realInvocation) => OpacityUpdating(1.0));
    });

    tearDown(() {
      gpsBloc.close();
      updateOpacityBloc.close();
      reverseGeocodeBloc.close();
    });

    testWidgets(
      'Display spinner when ReverseGeocodeState is GeocodingInProgress',
      (WidgetTester tester) async {
        when(reverseGeocodeBloc.state).thenAnswer((_) => GeocodingInProgress());
        await tester.pumpWidget(
          BlocProvider<ReverseGeocodeBloc>(
            create: (BuildContext context) => reverseGeocodeBloc,
            child: BlocProvider<UpdateOpacityBloc>(
              create: (context) => updateOpacityBloc,
              child: BlocProvider<GpsBloc>(
                create: (BuildContext context) => gpsBloc,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: MapScreenSpeedDial(),
                ),
              ),
            ),
          ),
        );
        await tester.pump();
        expect(find.byType(SpinKitDualRing), findsOneWidget);
        expect(find.byType(AnimatedIcon), findsNothing);
      },
    );

    testWidgets(
        'Displayed animated menu close icon when ReverseGeocodeState is GeocodingCompleted',
        (WidgetTester tester) async {
      when(reverseGeocodeBloc.state).thenAnswer((_) => GeocodingCompleted(
            null,
          ));
      await tester.pumpWidget(
        BlocProvider<ReverseGeocodeBloc>(
          create: (BuildContext context) => reverseGeocodeBloc,
          child: BlocProvider<UpdateOpacityBloc>(
            create: (context) => updateOpacityBloc,
            child: BlocProvider<GpsBloc>(
              create: (BuildContext context) => gpsBloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: MapScreenSpeedDial(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SpinKitDualRing), findsNothing);
      expect(find.byType(AnimatedIcon), findsOneWidget);
    });

    testWidgets(
        'Displayed animated menu close icon when MapState is GeocodingFailed',
        (WidgetTester tester) async {
      when(reverseGeocodeBloc.state).thenAnswer((_) => GeocodingFailed());
      await tester.pumpWidget(
        BlocProvider<ReverseGeocodeBloc>(
          create: (BuildContext context) => reverseGeocodeBloc,
          child: BlocProvider<UpdateOpacityBloc>(
            create: (context) => updateOpacityBloc,
            child: BlocProvider<GpsBloc>(
              create: (BuildContext context) => gpsBloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: MapScreenSpeedDial(),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(SpinKitDualRing), findsNothing);
      expect(find.byType(AnimatedIcon), findsOneWidget);
    });
  });
}
