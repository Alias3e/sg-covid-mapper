import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class MockWarningBloc extends MockBloc<WarningEvent, WarningState>
    implements WarningBloc {}

class MockCheckPanelBloc extends MockBloc<CheckPanelEvent, CheckPanelState>
    implements CheckPanelBloc {}

class MockLogBloc extends MockBloc<LogEvent, LogState> implements LogBloc {}

class MockMyVisitedPlaceRepository extends Mock
    implements MyVisitedPlaceRepository {}

class MockCovidPlacesRepository extends Mock implements CovidPlacesRepository {}

main() {
  MockCheckPanelBloc checkPanelBloc;
  MockMyVisitedPlaceRepository myVisitedPlaceRepository;
  MockCovidPlacesRepository covidPlacesRepository;
  MockLogBloc logBloc;
  List<List<CovidLocation>> covidPlaces = [[]];
  List<Visit> visits = [];
  WarningBloc warningBloc;

  setUp(() {
    checkPanelBloc = MockCheckPanelBloc();
    logBloc = MockLogBloc();
    myVisitedPlaceRepository = MockMyVisitedPlaceRepository();
    covidPlacesRepository = MockCovidPlacesRepository();
    when(covidPlacesRepository.covidLocations)
        .thenAnswer((realInvocation) => Stream.fromIterable(covidPlaces));
    when(myVisitedPlaceRepository.loadVisits()).thenReturn(visits);
    warningBloc = WarningBloc(
        checkPanelBloc: checkPanelBloc,
        visitsRepository: myVisitedPlaceRepository,
        logBloc: logBloc,
        covidRepository: covidPlacesRepository);
  });

  tearDown(() {
    checkPanelBloc.close();
    warningBloc.close();
    logBloc.close();
  });

  group('instantiation tests', () {
    test('throw AssertionError when checkPanelBloc is null', () {
      expect(
          () => WarningBloc(
                covidRepository: covidPlacesRepository,
                visitsRepository: myVisitedPlaceRepository,
                logBloc: logBloc,
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
                logBloc: logBloc,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when MyVisitedPlaceRepository is null', () {
      expect(
          () => WarningBloc(
                covidRepository: covidPlacesRepository,
                visitsRepository: null,
                checkPanelBloc: checkPanelBloc,
                logBloc: logBloc,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when LogBloc is null', () {
      expect(
          () => WarningBloc(
                covidRepository: covidPlacesRepository,
                visitsRepository: myVisitedPlaceRepository,
                checkPanelBloc: checkPanelBloc,
                logBloc: null,
              ),
          throwsAssertionError);
    });

    test('initial state is WarningLevelUnchanged()', () async {
      WarningBloc bloc = WarningBloc(
          covidRepository: covidPlacesRepository,
          visitsRepository: myVisitedPlaceRepository,
          logBloc: logBloc,
          checkPanelBloc: checkPanelBloc);

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

    blocTest(
        'emits DisplayAlerts when user visited a place where cases has also visited',
        build: () async => warningBloc,
        act: (bloc) => bloc.add(OnAlertFound([])),
        expect: [isA<DisplayAlerts>()]);
  });
}
