import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class MockWarningBloc extends MockBloc<WarningEvent, WarningState>
    implements WarningBloc {}

class MockCheckPanelBloc extends MockBloc<CheckPanelEvent, CheckPanelState>
    implements CheckPanelBloc {}

class MockMyVisitedPlaceRepository extends Mock
    implements MyVisitedPlaceRepository {}

class MockCovidPlacesRepository extends Mock implements CovidPlacesRepository {}

main() {
  MockCheckPanelBloc checkPanelBloc;
  MockMyVisitedPlaceRepository myVisitedPlaceRepository;
  MockCovidPlacesRepository covidPlacesRepository;
  List<List<CovidLocation>> covidPlaces = [[]];
  List<Visit> visits = [];
  WarningBloc warningBloc;

  setUp(() {
    checkPanelBloc = MockCheckPanelBloc();
    myVisitedPlaceRepository = MockMyVisitedPlaceRepository();
    covidPlacesRepository = MockCovidPlacesRepository();
    warningBloc = WarningBloc(
        checkPanelBloc: checkPanelBloc,
        visitsRepository: myVisitedPlaceRepository,
        covidRepository: covidPlacesRepository);
    when(covidPlacesRepository.covidLocations)
        .thenAnswer((realInvocation) => Stream.fromIterable(covidPlaces));
    when(myVisitedPlaceRepository.loadVisits()).thenReturn(visits);
  });

  tearDown(() {
    checkPanelBloc.close();
    warningBloc.close();
  });

  group('instantiation tests', () {
    test('throw AssertionError when checkPanelBloc is null', () {
      expect(
          () => WarningBloc(
                covidRepository: covidPlacesRepository,
                visitsRepository: myVisitedPlaceRepository,
                checkPanelBloc: null,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when CovidPlacesRepository is null', () {
      expect(
          () => WarningBloc(
                covidRepository: null,
                visitsRepository: myVisitedPlaceRepository,
                checkPanelBloc: checkPanelBloc,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when MyVisitedPlaceRepository is null', () {
      expect(
          () => WarningBloc(
                covidRepository: covidPlacesRepository,
                visitsRepository: null,
                checkPanelBloc: checkPanelBloc,
              ),
          throwsAssertionError);
    });

    test('initial state is WarningLevelUnchanged()', () async {
      WarningBloc bloc = WarningBloc(
          covidRepository: covidPlacesRepository,
          visitsRepository: myVisitedPlaceRepository,
          checkPanelBloc: checkPanelBloc);

      await untilCalled(covidPlacesRepository.init());
      expect(bloc.initialState, WarningLevelUnchanged());
      bloc.close();
    });
  });

  group('state transition tests', () {
    blocTest('emits WarningChanged when warning level is updated',
        build: () async => warningBloc,
        act: (bloc) =>
            bloc.add(WarningChanged(DateTime.now().millisecondsSinceEpoch)),
        expect: [isA<WarningLevelUpdated>()]);
  });
}
