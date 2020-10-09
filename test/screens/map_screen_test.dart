import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/widgets/map/map.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockBottomPanelBloc extends MockBloc<BottomPanelEvent, BottomPanelState>
    implements BottomPanelBloc {}

main() {
  group('Map Screen test', () {
    MapBloc mapBloc;
    SearchBloc searchBloc;
    BottomPanelBloc bottomPanelBloc;

    setUp(() {
      mapBloc = MockMapBloc();
      searchBloc = MockSearchBloc();
      bottomPanelBloc = MockBottomPanelBloc();
    });

    tearDown(() {
      mapBloc.close();
      searchBloc.close();
      bottomPanelBloc.close();
    });

    testWidgets(
      'Screen display correctly on startup',
      (WidgetTester tester) async {
        when(mapBloc.state).thenAnswer((_) => PlacesLoading());
        when(bottomPanelBloc.state).thenAnswer(
            (_) => BottomPanelClosed(isDraggable: false, maxHeight: 0));

        await tester.pumpWidget(
          MultiBlocProvider(
            providers: [
              BlocProvider<MapBloc>.value(value: mapBloc),
              BlocProvider<SearchBloc>.value(value: searchBloc),
              BlocProvider<BottomPanelBloc>.value(value: bottomPanelBloc),
            ],
            child: MaterialApp(
              home: MapScreen(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SpeedDial), findsNothing);
        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byType(SlidingUpPanel), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
      },
    );
  });
}
