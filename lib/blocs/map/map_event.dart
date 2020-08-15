//region Map Events
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/place_marker.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

// Event when Firestore stream has new places data.
class HasPlacesData extends MapEvent {
  final List<PlaceMarker> visitedPlaces;

  HasPlacesData(this.visitedPlaces);

  @override
  List<Object> get props => [visitedPlaces];
}

class GetGPS extends MapEvent {
  @override
  List<Object> get props => [];
}

class DisplayUserLocation extends MapEvent {
  @override
  List<Object> get props => [];
}

class CenterOnLocation extends MapEvent {
  final LatLng location;

  CenterOnLocation({this.location});

  @override
  List<Object> get props => [location];
}

class GeoCodeLocationSelected extends MapEvent {
  final double latitude;
  final double longitude;

  GeoCodeLocationSelected({@required this.latitude, @required this.longitude});
  @override
  List<Object> get props => [DateTime.now()];
}

class ClearOneMapPlacesMarker extends MapEvent {
  @override
  List<Object> get props => [];
}
//endregion
