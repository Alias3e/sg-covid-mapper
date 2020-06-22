import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/repositories/firestore_visited_place_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class MockGpsRepository extends Mock implements GpsRepository {}

class MockVisitedPlaceRepository extends Mock
    implements VisitedPlaceRepository {}

main() {
  group('MapBloc', () {
    MockGpsRepository mockGpsRepository;
    MockVisitedPlaceRepository mockVisitedPlaceRepository;
    Position position = Position(longitude: 103.1, latitude: 1.42);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    List<List<PlaceMarker>> markers = [
      [
        PlaceMarker(
            title: 'foo',
            subLocation: 'foo sub',
            startDate: Timestamp(1000, 0),
            endDate: Timestamp(2000, 0),
            point: LatLng(1.1, 100),
            builder: (context) => Container()),
        PlaceMarker(
            title: 'bar',
            subLocation: 'bar sub',
            startDate: Timestamp(3000, 0),
            endDate: Timestamp(4000, 0),
            point: LatLng(2.2, 125),
            builder: (context) => Container()),
      ]
    ];

    setUp(() {
      mockVisitedPlaceRepository = MockVisitedPlaceRepository();
      mockGpsRepository = MockGpsRepository();
      when(mockVisitedPlaceRepository.placeMarkers)
          .thenAnswer((_) => Stream.fromIterable(markers));
      when(mockVisitedPlaceRepository.cached).thenReturn(markers[0]);
    });

    tearDown(() {});

    test('has a correct initialState', () {
      MapBloc mapBloc = MapBloc(
          visitedPlaceRepository: mockVisitedPlaceRepository,
          gpsRepository: mockGpsRepository);
      expect(mapBloc.initialState, PlacesLoading());
      mapBloc.close();
    });

    test('throws AssertionError when visitedPlaceRepository is null', () {
      expect(
          () => MapBloc(
              visitedPlaceRepository: null, gpsRepository: mockGpsRepository),
          throwsAssertionError);
    });

    test('throws AssertionError when gpsRepository is null', () {
      expect(
          () => MapBloc(
              visitedPlaceRepository: mockVisitedPlaceRepository,
              gpsRepository: null),
          throwsAssertionError);
    });

    test('throws Exception when Firestore CollectionReference is null', () {
      expect(() => FirestoreVisitedPlaceRepository(null), throwsAssertionError);
    });

    group('Has Place Data event', () {
      blocTest(
        'emits [PlacesUpdated] when visitedPlaceRepository returns places',
        build: () async {
          return MapBloc(
              visitedPlaceRepository: mockVisitedPlaceRepository,
              gpsRepository: mockGpsRepository);
        },
        act: (bloc) async => bloc.add(HasPlacesData(markers[0])),
        expect: [PlacesUpdated(markers[0])],
      );
    });

    group('Fetch GPS events', () {
      blocTest(
        'emits [GpsLocationAcquiring, GpsLocationUpdated] when GPS is acquired',
        build: () async {
          when(mockGpsRepository.getCurrentLocation())
              .thenAnswer((_) => Future.value(position));
          return MapBloc(
              gpsRepository: mockGpsRepository,
              visitedPlaceRepository: mockVisitedPlaceRepository);
        },
        act: (bloc) async => bloc.add(GetGPS()),
        expect: [
          GpsLocationAcquiring(markers[0]),
          isA<GpsLocationUpdated>(),
        ],
        skip: 2,
      );
    });

    blocTest(
      'emits [GpsLocationAcquiring, GpsLocationFailed] when GPS is acquired',
      build: () async {
        when(mockGpsRepository.getCurrentLocation())
            .thenThrow(PlatformException(code: '100'));
        return MapBloc(
            gpsRepository: mockGpsRepository,
            visitedPlaceRepository: mockVisitedPlaceRepository);
      },
      act: (bloc) async => bloc.add(GetGPS()),
      expect: [
        GpsLocationAcquiring(markers[0]),
        GpsLocationFailed(markers[0]),
      ],
      skip: 2,
    );
  });
}
