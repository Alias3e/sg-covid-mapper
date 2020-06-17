import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

main() {
  group('Map Screen test', () {
    MapBloc mapBloc;

    setUp(() {
      mapBloc = MockMapBloc();
    });

    tearDown(() {
      mapBloc.close();
    });

    testWidgets(
      'Screen display correctly on startup',
      (WidgetTester tester) async {
        when(mapBloc.state).thenAnswer((_) => PlacesLoading());

        await tester.pumpWidget(
          BlocProvider<MapBloc>(
            create: (BuildContext context) => mapBloc,
            child: MaterialApp(
              home: MapScreen(
                mapController: MapController(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(FloatingActionButton), findsOneWidget);
        expect(find.byType(FlutterMap), findsOneWidget);
      },
    );
  });
}
