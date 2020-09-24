import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';

abstract class ReverseGeocodeState extends Equatable {}

class GeocodeInitial extends ReverseGeocodeState {
  @override
  List<Object> get props => [];
}

class GeocodingInProgress extends ReverseGeocodeState {
  @override
  List<Object> get props => [];
}

class GeocodingCompleted extends ReverseGeocodeState {
  final ReverseGeocode result;

  GeocodingCompleted(this.result);

  @override
  List<Object> get props => [result];
}

class GeocodingFailed extends ReverseGeocodeState {
  @override
  List<Object> get props => [];
}
