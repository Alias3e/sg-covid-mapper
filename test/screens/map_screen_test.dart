import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

main() {
  group('Map Screen test', () {
    MapBloc mapBloc;
    SearchBloc searchBloc;

    setUp(() {
      mapBloc = MockMapBloc();
      searchBloc = MockSearchBloc();
    });

    tearDown(() {
      mapBloc.close();
      searchBloc.close();
    });

    testWidgets(
      'Screen display correctly on startup',
      (WidgetTester tester) async {
        when(mapBloc.state).thenAnswer((_) => PlacesLoading());

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<MapBloc>.value(value: mapBloc),
              BlocProvider<SearchBloc>.value(value: searchBloc),
            ],
            child: MaterialApp(
              home: MapScreen(
                mapController: MapController(),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SpeedDial), findsOneWidget);
        expect(find.byType(FlutterMap), findsOneWidget);
      },
    );
  });
}
