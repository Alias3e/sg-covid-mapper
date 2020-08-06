import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong/latlong.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';

class MockReverseGeocodeBloc
    extends MockBloc<ReverseGeocodeEvent, ReverseGeocodeState>
    implements ReverseGeocodeBloc {}

class MockMapBloc extends MockBloc<MapEvent, MapState> implements MapBloc {}

class MockGeolocationRepository extends Mock implements GeolocationRepository {}

main() {
  MockMapBloc mapBloc;
  MockGeolocationRepository repository;
  LatLng latLng;

  setUp(() {
    mapBloc = MockMapBloc();
    repository = MockGeolocationRepository();
    latLng = LatLng(1.4, 103.5);
    when(repository.reverseGeocode(latLng.latitude, latLng.longitude))
        .thenAnswer((realInvocation) =>
            Future<ReverseGeocode>.value(ReverseGeocode([])));
  });

  tearDown(() {
    mapBloc.close();
  });

  group('instantiation test', () {
    test('throw AssertionError when GeolocationRepository is null', () {
      expect(
          () => ReverseGeocodeBloc(
                mapBloc: mapBloc,
                repository: null,
              ),
          throwsAssertionError);
    });

    test('throw AssertionError when MapBloc is null', () {
      expect(
          () => ReverseGeocodeBloc(
                mapBloc: null,
                repository: repository,
              ),
          throwsAssertionError);
    });

    test('initial state is GeocodeEmpty', () async {
      ReverseGeocodeBloc bloc =
          ReverseGeocodeBloc(repository: repository, mapBloc: mapBloc);

      expect(bloc.initialState, GeocodeInitial());
      bloc.close();
    });
  });

  group('states transition tests', () {
    blocTest(
      'emits [GeocodingInProgress, GeocodingCompleted] after BeginGeocode event',
      build: () async {
        return ReverseGeocodeBloc(mapBloc: mapBloc, repository: repository);
      },
      act: (bloc) async {
        bloc.add(BeginGeocode(LatLng(latLng.latitude, latLng.longitude)));
      },
      expect: [isA<GeocodingInProgress>(), isA<GeocodingCompleted>()],
    );
  });
}
