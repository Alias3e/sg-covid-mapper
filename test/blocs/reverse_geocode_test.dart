import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';

class MockReverseGeocodeBloc
    extends MockBloc<ReverseGeocodeEvent, ReverseGeocodeState>
    implements ReverseGeocodeBloc {}

class MockGpsBloc extends MockBloc<GpsEvent, GpsState> implements GpsBloc {}

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

main() {
  MockGpsBloc gpsBloc;
  MockGeolocationRepository repository;
  LatLng latLng;

  setUp(() {
    gpsBloc = MockGpsBloc();
    repository = MockGeolocationRepository();
    latLng = LatLng(1.4, 103.5);
  });

  tearDown(() {
    gpsBloc.close();
  });

  group('instantiation test', () {
    test('throw AssertionError when GeolocationRepository is null', () {
      expect(
          () => ReverseGeocodeBloc(
                gpsBloc: gpsBloc,
                repository: null,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when GpsBloc is null', () {
      expect(
          () => ReverseGeocodeBloc(
                gpsBloc: null,
                repository: repository,
              ),
          throwsAssertionError);
    });

    test('initial state is GeocodeEmpty', () async {
      ReverseGeocodeBloc bloc =
          ReverseGeocodeBloc(repository: repository, gpsBloc: gpsBloc);

      expect(bloc.initialState, GeocodeInitial());
      bloc.close();
    });
  });

  group('states transition tests', () {
    blocTest(
      'emits GeocodingInProgress after WaitingForLocation event',
      build: () async =>
          ReverseGeocodeBloc(gpsBloc: gpsBloc, repository: repository),
      act: (bloc) async {
        bloc.add(WaitingForLocation());
      },
      expect: [GeocodingInProgress()],
    );

    blocTest(
      'emits GeocodingCompleted after BeginGeocode event',
      build: () async {
        when(repository.reverseGeocode(latLng.latitude, latLng.longitude))
            .thenAnswer((realInvocation) =>
                Future<ReverseGeocode>.value(ReverseGeocode([])));
        return ReverseGeocodeBloc(gpsBloc: gpsBloc, repository: repository);
      },
      act: (bloc) async {
        bloc.add(BeginGeocode(LatLng(latLng.latitude, latLng.longitude)));
      },
      expect: [isA<GeocodingCompleted>()],
    );

    blocTest(
      'emits GeocodingFailed after failed BeginGeocode event',
      build: () async {
        return ReverseGeocodeBloc(gpsBloc: gpsBloc, repository: repository);
      },
      act: (bloc) async {
        when(repository.reverseGeocode(latLng.latitude, latLng.longitude))
            .thenAnswer((realInvocation) => Future.error(Exception()));
        bloc.add(BeginGeocode(LatLng(latLng.latitude, latLng.longitude)));
      },
      expect: [isA<GeocodingFailed>()],
    );
  });
}
