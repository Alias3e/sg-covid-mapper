import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location/location.dart';
import 'package:mockito/mockito.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';

class MockGpsRepository extends Mock implements GpsRepository {}

class MockLocationData extends Mock implements LocationData {}

main() {
  GpsRepository mockGpsRepository;
  LocationData position = MockLocationData();

  setUp(() {
    mockGpsRepository = MockGpsRepository();
  });

  group('initialization tests', () {
    test('throw AssertionError when GpsRepository is null', () {
      expect(() => GpsBloc(null), throwsAssertionError);
    });

    test('initial state is GpsNotAcquired', () async {
      GpsBloc bloc = GpsBloc(mockGpsRepository);

      expect(bloc.initialState, GpsNotAcquired());
      bloc.close();
    });
  });

  group('state transitions tests', () {
    blocTest(
      'emits [GpsAcquiring, GpsAcquired] after GetGps event',
      build: () async {
        when(position.latitude).thenReturn(1.42);
        when(position.longitude).thenReturn(103.5);
        when(mockGpsRepository.getCurrentLocation())
            .thenAnswer((realInvocation) => Future.value(position));
        return GpsBloc(mockGpsRepository);
      },
      act: (bloc) async => bloc.add(GetGps()),
      expect: [isA<GpsAcquiring>(), isA<GpsAcquired>()],
    );

    blocTest(
      'emits [GpsAcquiring, GpsAcquisitionFailed] if cannot get gps',
      build: () async {
        return GpsBloc(mockGpsRepository);
      },
      act: (bloc) async => bloc.add(GetGps()),
      expect: [isA<GpsAcquiring>(), isA<GpsAcquisitionFailed>()],
    );
  });
}
