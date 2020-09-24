import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';

class GpsBloc extends Bloc<GpsEvent, GpsState> {
  final GpsRepository gpsRepository;

  GpsBloc(this.gpsRepository) : assert(gpsRepository != null);
  @override
  GpsState get initialState => GpsNotAcquired();

  @override
  Stream<GpsState> mapEventToState(GpsEvent event) async* {
    if (event is GetGps) {
      yield GpsAcquiring();
      try {
        LocationData location = await gpsRepository.getCurrentLocation();
        yield GpsAcquired(LatLng(location.latitude, location.longitude));
      } catch (exception) {
        yield GpsAcquisitionFailed();
      }
    }
  }
}
