import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/widgets/data_information.dart';

import '../blocs/map_bloc_test.dart';

class MockCovidPlacesRepository extends Mock implements CovidPlacesRepository {}

class MockUpdateOpacityBloc
    extends MockBloc<UpdateOpacityEvent, UpdateOpacityState>
    implements UpdateOpacityBloc {}

main() {
  UpdateOpacityBloc bloc;
  CovidPlacesRepository repository;
  setUp(() {
    bloc = MockUpdateOpacityBloc();
    repository = MockVisitedPlaceRepository();
    when(bloc.state).thenAnswer((realInvocation) => WidgetFullyOpaque());
  });

  tearDown(() {
    bloc.close();
  });

  group('information container in map', () {
    testWidgets('display information layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider(
            create: (BuildContext context) => repository,
            child: BlocProvider<UpdateOpacityBloc>(
              create: (BuildContext context) => bloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    DataInformation(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.byType(Icon), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
      expect(find.byWidgetPredicate((widget) {
        if (widget is RichText &&
            widget.text.toPlainText() == 'View moh.gov.sg source data') {
          return true;
        }
        return false;
      }), findsOneWidget);
    });

    testWidgets('Test display updated time correctly',
        (WidgetTester tester) async {
      String fakeDateTimeString = Faker().date.time();
      when(repository.dataUpdated).thenReturn(fakeDateTimeString);
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider(
            create: (BuildContext context) => repository,
            child: BlocProvider<UpdateOpacityBloc>(
              create: (BuildContext context) => bloc,
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Stack(
                  children: [
                    DataInformation(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('App updated on $fakeDateTimeString'), findsOneWidget);
    });
  });
}
