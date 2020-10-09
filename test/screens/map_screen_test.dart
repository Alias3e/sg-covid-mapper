import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/data_information/data_information.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/screens/map_screen.dart';
import 'package:sgcovidmapper/widgets/map/map.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockBottomPanelBloc extends MockBloc<BottomPanelEvent, BottomPanelState>
    implements BottomPanelBloc {}

class MockWarningBloc extends MockBloc<WarningEvent, WarningState>
    implements WarningBloc {}

class MockUpdateOpacityBloc
    extends MockBloc<UpdateOpacityEvent, UpdateOpacityState>
    implements UpdateOpacityBloc {}

class MockDataInformationBloc
    extends MockBloc<DataInformationEvent, DataInformationState>
    implements DataInformationBloc {}

class MockReverseGeocodeBloc
    extends MockBloc<ReverseGeocodeEvent, ReverseGeocodeState>
    implements ReverseGeocodeBloc {}

class MockSearchTextFieldBloc
    extends MockBloc<SearchTextFieldEvent, SearchTextFieldState>
    implements SearchTextFieldBloc {}

main() {
  group('Map Screen test', () {
    MapBloc mapBloc;
    SearchBloc searchBloc;
    BottomPanelBloc bottomPanelBloc;
    WarningBloc warningBloc;
    UpdateOpacityBloc updateOpacityBloc;
    DataInformationBloc dataInformationBloc;
    ReverseGeocodeBloc reverseGeocodeBloc;
    SearchTextFieldBloc searchTextFieldBloc;

    setUp(() {
      mapBloc = MockMapBloc();
      searchBloc = MockSearchBloc();
      bottomPanelBloc = MockBottomPanelBloc();
      warningBloc = MockWarningBloc();
      updateOpacityBloc = MockUpdateOpacityBloc();
      when(updateOpacityBloc.state)
          .thenAnswer((realInvocation) => OpacityUpdating(1.0));
      dataInformationBloc = MockDataInformationBloc();
      reverseGeocodeBloc = MockReverseGeocodeBloc();
      searchTextFieldBloc = MockSearchTextFieldBloc();
    });

    tearDown(() {
      mapBloc.close();
      searchBloc.close();
      bottomPanelBloc.close();
      warningBloc.close();
      updateOpacityBloc.close();
      dataInformationBloc.close();
      reverseGeocodeBloc.close();
      searchTextFieldBloc.close();
    });

    testWidgets(
      'Screen display correctly on startup',
      (WidgetTester tester) async {
        when(mapBloc.state).thenAnswer((_) => PlacesLoading());
        when(bottomPanelBloc.state).thenAnswer(
            (_) => BottomPanelClosed(isDraggable: false, maxHeight: 0));

        await tester.pumpWidget(
          MaterialApp(
            home: MultiBlocProvider(
              providers: [
                BlocProvider<MapBloc>.value(value: mapBloc),
                BlocProvider<SearchBloc>.value(value: searchBloc),
                BlocProvider<BottomPanelBloc>.value(value: bottomPanelBloc),
                BlocProvider<WarningBloc>.value(value: warningBloc),
                BlocProvider<UpdateOpacityBloc>.value(value: updateOpacityBloc),
                BlocProvider<DataInformationBloc>.value(
                    value: dataInformationBloc),
                BlocProvider<ReverseGeocodeBloc>.value(
                    value: reverseGeocodeBloc),
                BlocProvider<SearchTextFieldBloc>.value(
                    value: searchTextFieldBloc),
              ],
              child: ShowCaseWidget(
                builder: Builder(
                  builder: (BuildContext context) => MapScreen(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byType(SpeedDial), findsOneWidget);
        expect(find.byType(FlutterMap), findsOneWidget);
        expect(find.byType(SlidingUpPanel), findsOneWidget);
        expect(find.byType(SearchTextField), findsOneWidget);
        expect(find.byType(DataInformationWidget), findsOneWidget);
      },
    );
  });
}
