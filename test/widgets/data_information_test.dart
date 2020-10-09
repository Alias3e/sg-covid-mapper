import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/data_information/data_information.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/map/map.dart';

import '../blocs/map_bloc_test.dart';

class MockCovidPlacesRepository extends Mock implements CovidPlacesRepository {}

class MockUpdateOpacityBloc
    extends MockBloc<UpdateOpacityEvent, UpdateOpacityState>
    implements UpdateOpacityBloc {}

class MockDataInformationBloc
    extends MockBloc<DataInformationEvent, DataInformationState>
    implements DataInformationBloc {}

main() {
  UpdateOpacityBloc bloc;
  MockDataInformationBloc dataInformationBloc;
  CovidPlacesRepository repository;
  setUp(() {
    bloc = MockUpdateOpacityBloc();
    repository = MockVisitedPlaceRepository();
    dataInformationBloc = MockDataInformationBloc();
    when(bloc.state).thenAnswer((realInvocation) => WidgetFullyOpaque());
  });

  tearDown(() {
    bloc.close();
    dataInformationBloc.close();
  });

  group('information container in map', () {
    testWidgets('display information layout', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider(
            create: (BuildContext context) => repository,
            child: BlocProvider<DataInformationBloc>(
              create: (context) => dataInformationBloc,
              child: BlocProvider<UpdateOpacityBloc>(
                create: (BuildContext context) => bloc,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Stack(
                    children: [
                      DataInformationWidget(),
                    ],
                  ),
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
            widget.text.toPlainText() == 'Source data courtesy of moh.gov.sg') {
          return true;
        }
        return false;
      }), findsOneWidget);
    });

    testWidgets('Test display updated time correctly',
        (WidgetTester tester) async {
      Faker faker = Faker();
      String date = Styles.kUpdatedDateFormat.format(faker.date.dateTime());
      when(dataInformationBloc.state).thenAnswer((_) => DataInformationUpdated({
            'version': faker.lorem.word(),
            'source': faker.internet.httpsUrl(),
            'updated': date,
          }));
      await tester.pumpWidget(
        MaterialApp(
          home: RepositoryProvider(
            create: (BuildContext context) => repository,
            child: BlocProvider<DataInformationBloc>(
              create: (BuildContext context) => dataInformationBloc,
              child: BlocProvider<UpdateOpacityBloc>(
                create: (BuildContext context) => bloc,
                child: Directionality(
                  textDirection: TextDirection.ltr,
                  child: Stack(
                    children: [
                      DataInformationWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('App data updated on $date'), findsOneWidget);
    });
  });
}
