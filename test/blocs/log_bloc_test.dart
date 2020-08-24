import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class MockMyVisitedPlaceRepository extends Mock
    implements MyVisitedPlaceRepository {}

main() {
  MyVisitedPlaceRepository repository;
  Visit visit;

  setUp(() {
    repository = MockMyVisitedPlaceRepository();
    visit = Visit();
  });

  group('initialization tests', () {
    test('initial state is LogStateInitial', () async {
      LogBloc bloc = LogBloc(repository);

      expect(bloc.initialState, LogStateInitial());
      bloc.close();
    });

    test('throw AssertionError when MyVistedPlaceRepository is null', () {
      expect(() => LogBloc(null), throwsAssertionError);
    });
  });

  group('state transition tests', () {
    blocTest(
      'emits [DeleteConfirmationShowing] after user press delete button',
      build: () async {
        return LogBloc(repository);
      },
      act: (bloc) async {
        bloc.add(OnDeleteButtonPressed(visit));
      },
      expect: [isA<DeleteConfirmationPanelShowing>()],
    );

    blocTest(
      'emits [VisitDeleteInProgress, VisitDeleteCompleted] after user confirm deletion',
      build: () async {
        return LogBloc(repository);
      },
      act: (bloc) async {
        bloc.add(OnDeleteConfirmed(visit));
      },
      expect: [
        isA<VisitDeleteInProgress>(),
        isA<VisitDeleteCompleted>(),
      ],
    );

    blocTest(
      'emits [CheckOutPanelShowing] after user press check out button',
      build: () async {
        return LogBloc(repository);
      },
      act: (bloc) async {
        bloc.add(OnCheckOutButtonPressed(visit: visit));
      },
      expect: [isA<CheckOutPanelShowing>()],
    );

    blocTest(
      'emits [VisitUpdateInProgress, VisitUpdateCompleted] after user update visit',
      build: () async {
        return LogBloc(repository);
      },
      act: (bloc) async {
        bloc.add(OnVisitUpdated(visit));
      },
      expect: [isA<VisitUpdateInProgress>(), isA<VisitUpdateCompleted>()],
    );
  });
}
