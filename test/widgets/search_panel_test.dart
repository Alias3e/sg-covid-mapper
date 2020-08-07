import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/one_map.dart';
import 'package:sgcovidmapper/widgets/widgets.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockBottomPanelBloc extends MockBloc<BottomPanelBloc, BottomPanelState>
    implements BottomPanelBloc {}

main() {
  group('Search Panel Test', () {
    SearchBloc searchBloc;
    MapBloc mapBloc;
    BottomPanelBloc bottomPanelBloc;
    Faker faker;

    setUp(() {
      searchBloc = MockSearchBloc();
      mapBloc = MockMapBloc();
      bottomPanelBloc = MockBottomPanelBloc();
      faker = Faker();
    });

    tearDown(() {
      searchBloc.close();
      mapBloc.close();
      bottomPanelBloc.close();
    });

    testWidgets('search panel populates one search result properly',
        (WidgetTester tester) async {
      List<CommonOneMapModel> results = [
        CommonOneMapModel.fromSearchResultModel(
          OneMapSearchResult(
            searchValue: faker.lorem.word(),
            address: faker.address.streetAddress(),
            postalCode: faker.address.zipCode(),
            longitudeString: faker.randomGenerator.decimal().toString(),
            latitudeString: faker.randomGenerator.decimal().toString(),
          ),
        )
      ];
      OneMapSearch search = OneMapSearch(results);
      when(searchBloc.state).thenAnswer((_) => SearchResultLoaded(search, -1));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<BottomPanelBloc>.value(value: bottomPanelBloc),
            BlocProvider<SearchBloc>.value(value: searchBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchPanel(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      expect(find.text(results[0].title), findsOneWidget);
      expect(find.text(results[0].subtitle), findsOneWidget);
    });

    testWidgets('search panel populates multiple search result properly',
        (WidgetTester tester) async {
      List<CommonOneMapModel> results = [
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.lorem.word(),
          address: faker.address.streetAddress(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.randomGenerator.decimal().toString(),
          latitudeString: faker.randomGenerator.decimal().toString(),
        )),
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.lorem.word(),
          address: faker.address.streetAddress(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.randomGenerator.decimal().toString(),
          latitudeString: faker.randomGenerator.decimal().toString(),
        )),
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.lorem.word(),
          address: faker.address.streetAddress(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.randomGenerator.decimal().toString(),
          latitudeString: faker.randomGenerator.decimal().toString(),
        )),
      ];
      OneMapSearch search = OneMapSearch(results);
      when(searchBloc.state).thenAnswer((_) => SearchResultLoaded(search, -1));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<BottomPanelBloc>.value(value: bottomPanelBloc),
            BlocProvider<SearchBloc>.value(value: searchBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchPanel(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ListTile), findsNWidgets(results.length));
      for (final result in results) {
        expect(find.text(result.title), findsOneWidget);
      }
      for (final result in results) {
        expect(find.text(result.subtitle), findsOneWidget);
      }
    });

    testWidgets('search panel populates empty result properly',
        (WidgetTester tester) async {
      List<CommonOneMapModel> results = [];
      OneMapSearch search = OneMapSearch(results);
      when(searchBloc.state).thenAnswer((_) => SearchResultLoaded(search, -1));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<BottomPanelBloc>.value(value: bottomPanelBloc),
            BlocProvider<SearchBloc>.value(value: searchBloc),
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchPanel(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ListTile), findsNothing);
    });

    testWidgets(
        'verify CenterOnLocation, SearchLocationTapped events are fired when list tile is tapped',
        (WidgetTester tester) async {
      List<CommonOneMapModel> results = [
        CommonOneMapModel.fromSearchResultModel(OneMapSearchResult(
          searchValue: faker.lorem.word(),
          address: faker.address.streetAddress(),
          postalCode: faker.address.zipCode(),
          longitudeString: faker.randomGenerator.decimal().toString(),
          latitudeString: faker.randomGenerator.decimal().toString(),
        )),
      ];
      OneMapSearch search = OneMapSearch(results);
      when(searchBloc.state).thenAnswer((_) => SearchResultLoaded(search, 1));

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider<BottomPanelBloc>.value(
              value: bottomPanelBloc,
            ),
            BlocProvider<MapBloc>.value(
              value: mapBloc,
            ),
            BlocProvider<SearchBloc>.value(
              value: searchBloc,
            )
          ],
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchPanel(),
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.byType(ListTile), findsOneWidget);
      await tester.tap(find.byType(ListTile));
      verify(mapBloc.add(CenterOnLocation(
          location: LatLng(results[0].latitude, results[0].longitude))));
      verify(searchBloc.add(SearchLocationTapped(0)));
    });
  });
}
