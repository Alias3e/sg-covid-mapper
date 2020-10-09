import 'package:bloc_test/bloc_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/repositories.dart';

import 'reverse_geocode_test.dart';

class MockVisitedPlaceRepository extends Mock implements CovidPlacesRepository {
}

main() {
  group('MapBloc', () {
    MockVisitedPlaceRepository mockVisitedPlaceRepository;
    MockReverseGeocodeBloc mockReverseGeocodeBloc;
    MockGpsBloc mockGpsBloc;

    LatLng latLng = LatLng(1.42, 103.5);
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
      mockReverseGeocodeBloc = MockReverseGeocodeBloc();
      mockGpsBloc = MockGpsBloc();
      when(mockVisitedPlaceRepository.placeMarkers)
          .thenAnswer((_) => Stream.fromIterable(markers));
      when(mockVisitedPlaceRepository.placeMarkersCached)
          .thenReturn(markers[0]);
    });

    tearDown(() {
      mockGpsBloc.close();
      mockReverseGeocodeBloc.close();
    });

    test('throws Exception when Firestore CollectionReference is null', () {
      expect(() => FirestoreCovidPlacesRepository(remoteDatabaseService: null),
          throwsAssertionError);
    });

    test('throws AssertionError when visitedPlaceRepository is null', () {
      expect(
          () => MapBloc(
              covidPlacesRepository: null,
              gpsBloc: mockGpsBloc,
              reverseGeocodeBloc: mockReverseGeocodeBloc),
          throwsAssertionError);
    });

    test('throws AssertionError when gpsBloc is null', () {
      expect(
          () => MapBloc(
              covidPlacesRepository: mockVisitedPlaceRepository,
              gpsBloc: null,
              reverseGeocodeBloc: mockReverseGeocodeBloc),
          throwsAssertionError);
    });

    test('throws AssertionError when reverseGeocodeBloc is null', () {
      expect(
          () => MapBloc(
              covidPlacesRepository: mockVisitedPlaceRepository,
              gpsBloc: mockGpsBloc,
              reverseGeocodeBloc: null),
          throwsAssertionError);
    });

    test('has correct initial state', () async {
      MapBloc mapBloc = MapBloc(
          gpsBloc: mockGpsBloc,
          covidPlacesRepository: mockVisitedPlaceRepository,
          reverseGeocodeBloc: mockReverseGeocodeBloc);
      expect(mapBloc.initialState, PlacesLoading());
      mapBloc.close();
    });

    group('Has Place Data event', () {
      blocTest(
        'emits [PlacesUpdated] when visitedPlaceRepository returns places',
        build: () async {
          return MapBloc(
              gpsBloc: mockGpsBloc,
              covidPlacesRepository: mockVisitedPlaceRepository,
              reverseGeocodeBloc: mockReverseGeocodeBloc);
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
          gpsBloc: mockGpsBloc,
          covidPlacesRepository: mockVisitedPlaceRepository,
          reverseGeocodeBloc: mockReverseGeocodeBloc,
        );
      },
      act: (bloc) async {
        bloc.add(CenterOnLocation(location: latLng));
      },
      expect: [isA<MapViewBoundsChanged>()],
      skip: 2,
    );

    blocTest(
      'Emits MapViewBoundChanged when displaying user location and nearby places',
      build: () async => MapBloc(
        gpsBloc: mockGpsBloc,
        covidPlacesRepository: mockVisitedPlaceRepository,
        reverseGeocodeBloc: mockReverseGeocodeBloc,
      ),
      act: (bloc) async {
        bloc.add(OnGpsLocationAcquired(location: latLng));
        bloc.add(DisplayUserAndNearbyMarkers());
      },
      expect: [isA<MapViewBoundsChanged>()],
      skip: 2,
    );

    blocTest(
      'Emits MapUpdated when user clicks on nearby places',
      build: () async => MapBloc(
        gpsBloc: mockGpsBloc,
        covidPlacesRepository: mockVisitedPlaceRepository,
        reverseGeocodeBloc: mockReverseGeocodeBloc,
      ),
      act: (bloc) async {
        bloc.add(GeoCodeLocationSelected(
            longitude: latLng.longitude, latitude: latLng.latitude));
      },
      expect: [isA<MapUpdated>()],
      skip: 2,
    );

    blocTest(
      'Emnits MapUpdated when the map markers are cleared when panel closes',
      build: () async => MapBloc(
        gpsBloc: mockGpsBloc,
        covidPlacesRepository: mockVisitedPlaceRepository,
        reverseGeocodeBloc: mockReverseGeocodeBloc,
      ),
      act: (bloc) async {
        bloc.add(GeoCodeLocationSelected(
            longitude: latLng.longitude, latitude: latLng.latitude));
        bloc.add(ClearOneMapPlacesMarker());
      },
      expect: [isA<MapUpdated>()],
      skip:
          3, // skips 3 because of initial state, mapupdated is emitted once when covid places are fetched, then again for geocodelocation is selected.
    );
  });
}
