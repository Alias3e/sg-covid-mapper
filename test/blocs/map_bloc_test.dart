import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/repositories.dart';

class MockGpsRepository extends Mock implements GpsRepository {}

class MockVisitedPlaceRepository extends Mock implements CovidPlacesRepository {
}

class MockLocationData extends Mock implements LocationData {}

main() {
  group('MapBloc', () {
    MockGpsRepository mockGpsRepository;
    MockVisitedPlaceRepository mockVisitedPlaceRepository;
    LocationData position = MockLocationData();
    when(position.latitude).thenReturn(1.42);
    when(position.longitude).thenReturn(103.5);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    List<Marker> nearbyPlaces = [];
    List<List<PlaceMarker>> markers = [
      [
        PlaceMarker(
            title: 'foo',
            subtitle: 'foo sub',
            startTime: Timestamp(1000, 0),
            endTime: Timestamp(2000, 0),
            point: LatLng(1.1, 100),
            builder: (context) => Container()),
        PlaceMarker(
            title: 'bar',
            subtitle: 'bar sub',
            startTime: Timestamp(3000, 0),
            endTime: Timestamp(4000, 0),
            point: LatLng(2.2, 125),
            builder: (context) => Container()),
      ]
    ];

    setUp(() {
      mockVisitedPlaceRepository = MockVisitedPlaceRepository();
      mockVisitedPlaceRepository.init();
      mockGpsRepository = MockGpsRepository();
      when(mockVisitedPlaceRepository.placeMarkers)
          .thenAnswer((_) => Stream.fromIterable(markers));
      when(mockVisitedPlaceRepository.placeMarkersCached)
          .thenReturn(markers[0]);
    });

    test('throws AssertionError when visitedPlaceRepository is null', () {
      expect(
          () => MapBloc(
              covidPlacesRepository: null, gpsRepository: mockGpsRepository),
          throwsAssertionError);
    });

    test('throws Exception when Firestore CollectionReference is null', () {
      expect(() => FirestoreCovidPlacesRepository(), throwsAssertionError);
    });

    test('has correct initial state', () async {
      MapBloc mapBloc = MapBloc(
          covidPlacesRepository: mockVisitedPlaceRepository,
          gpsRepository: mockGpsRepository);
      await untilCalled(mockVisitedPlaceRepository.init());
      expect(mapBloc.initialState, PlacesLoading());
      mapBloc.close();
    });

    test('throws AssertionError when gpsRepository is null', () {
      expect(
          () => MapBloc(
              covidPlacesRepository: mockVisitedPlaceRepository,
              gpsRepository: null),
          throwsAssertionError);
    });

    group('Has Place Data event', () {
      blocTest(
        'emits [PlacesUpdated] when visitedPlaceRepository returns places',
        build: () async {
          return MapBloc(
              covidPlacesRepository: mockVisitedPlaceRepository,
              gpsRepository: mockGpsRepository);
        },
        act: (bloc) async => bloc.add(HasPlacesData(markers[0])),
        expect: [
          MapUpdated(covidPlaces: markers[0], nearbyPlaces: nearbyPlaces)
        ],
      );
    });

    blocTest(
      'Emits MapViewBoundChanged when user taps on a searched location',
      build: () async {
        return MapBloc(
            covidPlacesRepository: mockVisitedPlaceRepository,
            gpsRepository: mockGpsRepository);
      },
      act: (bloc) async {
        await untilCalled(mockVisitedPlaceRepository.init());
        bloc.add(CenterOnLocation(location: latLng));
      },
      expect: [isA<MapViewBoundsChanged>()],
      skip: 2,
    );

    group('Fetch GPS events', () {
      blocTest(
        'emits [GpsLocationAcquiring, GpsLocationUpdated] when GPS is acquired',
        build: () async {
          when(mockGpsRepository.getCurrentLocation())
              .thenAnswer((_) => Future.value(position));
          return MapBloc(
              gpsRepository: mockGpsRepository,
              covidPlacesRepository: mockVisitedPlaceRepository);
        },
        act: (bloc) async {
          await untilCalled(mockVisitedPlaceRepository.init());
          bloc.add(GetGPS());
        },
        expect: [
          GpsLocationAcquiring(
              covidPlaces: markers[0], nearbyPlaces: nearbyPlaces),
          isA<GPSAcquired>(),
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
            covidPlacesRepository: mockVisitedPlaceRepository);
      },
      act: (bloc) async {
        await untilCalled(mockVisitedPlaceRepository.init());
        bloc.add(GetGPS());
      },
      expect: [
        GpsLocationAcquiring(
            covidPlaces: markers[0], nearbyPlaces: nearbyPlaces),
        GpsLocationFailed(covidPlaces: markers[0], nearbyPlaces: nearbyPlaces),
      ],
      skip: 2,
    );
  });
}
