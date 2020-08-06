import 'package:equatable/equatable.dart';
import 'package:latlong/latlong.dart';

abstract class ReverseGeocodeEvent extends Equatable {}

class BeginGeocode extends ReverseGeocodeEvent {
  final LatLng latLng;

  BeginGeocode(this.latLng);

  @override
  List<Object> get props => [latLng];
}
