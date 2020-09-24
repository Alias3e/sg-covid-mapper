import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';

abstract class GpsState extends Equatable {}

class GpsNotAcquired extends GpsState {
  @override
  List<Object> get props => [];
}

class GpsAcquiring extends GpsState {
  @override
  List<Object> get props => [];
}

class GpsAcquired extends GpsState {
  final LatLng location;

  GpsAcquired(this.location);
  @override
  List<Object> get props => [location];
}

class GpsAcquisitionFailed extends GpsState {
  @override
  List<Object> get props => [];
}
