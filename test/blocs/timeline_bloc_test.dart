import 'package:bloc_test/bloc_test.dart';
import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_bloc.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_event.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_state.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class MockTimelineBloc extends MockBloc<TimelineEvent, TimelineState>
    implements TimelineBloc {}

class MockCovidPlaceRepository extends Mock implements CovidPlacesRepository {}

class MockMyVisitedPlaceRepository extends Mock
    implements MyVisitedPlaceRepository {}

main() {
  group('Timeline bloc instantiation tests', () {
    TimelineBloc bloc;
    MyVisitedPlaceRepository visitedPlaceRepository;
    CovidPlacesRepository covidPlacesRepository;
    Faker faker = Faker();
    List<List<ChildTimelineItem>> mockLocationTimelineItem = [
      [
        LocationTimelineItem(
            startTime: DateTime.now(),
            endTime: DateTime.now(),
            title: faker.lorem.sentence(),
            subtitle: faker.lorem.sentence(),
            lineX: 0.5),
      ]
    ];

    List<ChildTimelineItem> mockVisitTimelineItem = [
      VisitTimelineItem(
        startTime: DateTime.now(),
        endTime: DateTime.now(),
        title: faker.lorem.sentence(),
        tags: [],
        lineX: 0.85,
        warningLevel: WarningLevel.none,
      ),
    ];

    setUp(() {
      bloc = MockTimelineBloc();
      visitedPlaceRepository = MockMyVisitedPlaceRepository();
      covidPlacesRepository = MockCovidPlaceRepository();
      when(covidPlacesRepository.timelineTiles).thenAnswer(
          (realInvocation) => Stream.fromIterable(mockLocationTimelineItem));
      when(covidPlacesRepository.timelineItemCached)
          .thenAnswer((realInvocation) => mockLocationTimelineItem[0]);
      when(visitedPlaceRepository.loadVisits())
          .thenReturn(mockVisitTimelineItem);
    });

    tearDown(() {
      bloc.close();
    });

    test('throw AssertionError when CovidPlacesRepository is null', () {
      expect(
          () => TimelineBloc(
              covidRepository: null, visitsRepository: visitedPlaceRepository),
          throwsAssertionError);
    });

    test('throw AssertionError when MyVisitedPaceRepository is null', () {
      expect(
          () => TimelineBloc(
              covidRepository: covidPlacesRepository, visitsRepository: null),
          throwsAssertionError);
    });

    test('initial state is TimelineEmpty', () async {
      TimelineBloc bloc = TimelineBloc(
          covidRepository: covidPlacesRepository,
          visitsRepository: visitedPlaceRepository);
      await untilCalled(covidPlacesRepository.init());
      expect(bloc.initialState, TimelineEmpty());
      bloc.close();
    });

    blocTest(
      'emits [HasTimeLineData] when covid or visited places data source is updated or fetched',
      build: () async {
        return TimelineBloc(
          visitsRepository: visitedPlaceRepository,
          covidRepository: covidPlacesRepository,
        );
      },
      act: (bloc) async {
        await untilCalled(covidPlacesRepository.init());
        await Future.delayed(Duration(seconds: 1));
        bloc.add(HasTimelineData(mockLocationTimelineItem[0]));
      },
      // Update from covid and visit data sources, so 2 calls.
      expect: [isA<TimelineLoaded>(), isA<TimelineLoaded>()],
    );
  });
}
