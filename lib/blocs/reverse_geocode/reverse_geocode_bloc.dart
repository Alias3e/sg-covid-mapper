import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';

class ReverseGeocodeBloc
    extends Bloc<ReverseGeocodeEvent, ReverseGeocodeState> {
  final GeolocationRepository repository;
  final GpsBloc gpsBloc;

  ReverseGeocodeBloc({
    @required this.repository,
    @required this.gpsBloc,
  }) : assert(repository != null && gpsBloc != null) {
    gpsBloc.listen((state) {
      if (state is GpsAcquiring) add(WaitingForLocation());
      if (state is GpsAcquired) add(BeginGeocode(state.location));
    });
  }

  @override
  ReverseGeocodeState get initialState => GeocodeInitial();

  @override
  Stream<ReverseGeocodeState> mapEventToState(
      ReverseGeocodeEvent event) async* {
    if (event is WaitingForLocation) yield GeocodingInProgress();

    if (event is BeginGeocode) {
      try {
        ReverseGeocode result = await repository.reverseGeocode(
            event.latLng.latitude, event.latLng.longitude);
        yield GeocodingCompleted(result);
      } catch (_) {
        yield GeocodingFailed();
      }
    }
  }

  @override
  Future<void> close() {
    gpsBloc.close();
    return super.close();
  }
}
