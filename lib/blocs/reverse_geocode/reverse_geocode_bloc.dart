import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/repositories/GeolocationRepository.dart';

class ReverseGeocodeBloc
    extends Bloc<ReverseGeocodeEvent, ReverseGeocodeState> {
  final GeolocationRepository repository;
  final MapBloc mapBloc;

  ReverseGeocodeBloc({@required this.repository, @required this.mapBloc})
      : assert(repository != null && mapBloc != null) {
    print('reverse geocode bloc');
    mapBloc.listen((state) {
      if (state is GPSAcquired) {
        add(BeginGeocode(state.mapCenter));
      }
    });
  }

  @override
  ReverseGeocodeState get initialState => GeocodeInitial();

  @override
  Stream<ReverseGeocodeState> mapEventToState(
      ReverseGeocodeEvent event) async* {
    if (event is BeginGeocode) {
      yield GeocodingInProgress();
      ReverseGeocode result = await repository.reverseGeocode(
          event.latLng.latitude, event.latLng.longitude);
      print(result.results);
      yield GeocodingCompleted(result);
    }
  }

  @override
  Future<void> close() {
    mapBloc.close();
    return super.close();
  }
}
