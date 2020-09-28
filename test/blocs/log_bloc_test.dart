import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/log/log.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class MockMyVisitedPlaceRepository extends Mock
    implements MyVisitedPlaceRepository {}

class MockCovidPlacesRepository extends Mock implements CovidPlacesRepository {}

main() {
  MyVisitedPlaceRepository myVisitedPlacesRepository;
  Visit visit;

  setUp(() {
    myVisitedPlacesRepository = MockMyVisitedPlaceRepository();
    visit = Visit();
  });

  group('initialization tests', () {
    test('initial state is LogStateInitial', () async {
      LogBloc bloc = LogBloc(myVisitedPlacesRepository);

      expect(bloc.initialState, LogStateInitial());
      bloc.close();
    });

    test('throw AssertionError when MyVistedPlaceRepository is null', () {
      expect(() => LogBloc(null), throwsAssertionError);
    });

    group('state transition tests', () {
      blocTest(
        'emits [DeleteConfirmationShowing] after user press delete button',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnDeleteButtonPressed(visit));
        },
        expect: [isA<DeleteConfirmationPanelShowing>()],
      );

      blocTest(
        'emits [VisitDeleteInProgress, VisitDeleteCompleted] after user confirm deletion',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
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
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnCheckOutButtonPressed(visit: visit));
        },
        expect: [isA<CheckOutPanelShowing>()],
      );

      blocTest(
        'emits [VisitUpdateInProgress, VisitUpdateCompleted] after user update visit',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnVisitUpdated(visit));
        },
        expect: [isA<VisitUpdateInProgress>(), isA<VisitUpdateCompleted>()],
      );

      blocTest(
        'emits [CheckOutPickerDisplayed] after user pressed check out button in edit visit panel',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnEditPanelCheckOutButtonPressed());
        },
        expect: [isA<CheckOutPickerDisplayed>()],
      );

      blocTest(
        'emits [EditCheckInDateTimeUpdated] after user change the check in time picker',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnCheckInDateTimeSpinnerChanged(DateTime.now()));
        },
        expect: [isA<EditCheckInDateTimeUpdated>()],
      );

      blocTest(
        'emits [EditCheckOutDateTimeUpdated] after user change the check out time picker',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnCheckOutDateTimeSpinnerChanged(DateTime.now()));
        },
        expect: [isA<EditCheckOutDateTimeUpdated>()],
      );

      blocTest(
        'emits [TagsUpdated] after user delete a tag',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnTagDeleteButtonPressed(Tag(Faker().lorem.word())));
        },
        expect: [isA<TagsUpdated>()],
      );

      blocTest(
        'emits [TagsUpdated] after user add a new tag',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnTagAdded(Tag(Faker().lorem.word())));
        },
        expect: [isA<TagsUpdated>()],
      );

      blocTest(
        'emits [TagsUpdated] after user edit existing tag',
        build: () async {
          return LogBloc(myVisitedPlacesRepository);
        },
        wait: Duration(milliseconds: 100),
        act: (bloc) async {
          bloc.add(OnTagEdited(Tag(Faker().lorem.word())));
        },
        expect: [isA<TagsUpdated>()],
      );
    });
  });
}
