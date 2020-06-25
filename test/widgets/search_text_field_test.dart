import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/search/search_bloc.dart';
import 'package:sgcovidmapper/blocs/search/search_event.dart';
import 'package:sgcovidmapper/models/one_map_search.dart';
import 'package:sgcovidmapper/models/one_map_search_result.dart';
import 'package:sgcovidmapper/widgets/search_text_field.dart';

class MockSearchBloc extends MockBloc<SearchEvent, SearchState>
    implements SearchBloc {}

main() {
  Faker faker;
  List<OneMapSearchResult> results = [];

  group('Search TextField', () {
    SearchBloc bloc;

    setUp(() {
      bloc = MockSearchBloc();
      faker = Faker();
    });

    tearDown(() {
      bloc.close();
    });

    testWidgets(
        'Search TextField does not display close icon when search box is not focused',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => SearchEmpty());
      await tester.pumpWidget(
        BlocProvider<SearchBloc>.value(
          value: bloc,
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchTextField(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Icon), findsNothing);
    });

    testWidgets(
        'Search TextField display close icon when search box focused but empty',
        (WidgetTester tester) async {
      when(bloc.state).thenAnswer((_) => SearchStarting());
      await tester.pumpWidget(
        BlocProvider<SearchBloc>.value(
          value: bloc,
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchTextField(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets(
        'Search TextField display close icon when user is typing but results is empty',
        (WidgetTester tester) async {
      when(bloc.state)
          .thenAnswer((_) => SearchResultLoaded(OneMapSearch(results)));
      await tester.pumpWidget(
        BlocProvider<SearchBloc>.value(
          value: bloc,
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchTextField(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets(
        'Search TextField display close icon when user is typing but results is not empty',
        (WidgetTester tester) async {
      for (int i = 0; i < 3; i++) {
        results.add(OneMapSearchResult(
            searchValue: faker.lorem.word(),
            postalCode: faker.address.zipCode(),
            latitudeString: faker.randomGenerator.decimal().toString(),
            longitudeString: faker.randomGenerator.decimal().toString()));
      }

      when(bloc.state)
          .thenAnswer((_) => SearchResultLoaded(OneMapSearch(results)));
      await tester.pumpWidget(
        BlocProvider<SearchBloc>.value(
          value: bloc,
          child: MaterialApp(
            home: Scaffold(
              body: Directionality(
                textDirection: TextDirection.ltr,
                child: SearchTextField(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(TextField), findsOneWidget);
      expect(find.byType(Icon), findsOneWidget);
    });
  });
}
