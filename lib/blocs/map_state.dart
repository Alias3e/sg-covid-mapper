//region Map States
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/place_marker.dart';

abstract class MapState extends Equatable {
  final List<PlaceMarker> places;
  const MapState(this.places);
}

class PlacesLoading extends MapState {
  PlacesLoading() : super([]);

  @override
  List<Object> get props => [];
}

class PlacesUpdated extends MapState {
  PlacesUpdated(List<PlaceMarker> places) : super(places);

  @override
  List<Object> get props => [places];
}

class PlacesError extends MapState {
  PlacesError(List<PlaceMarker> places) : super(places);

  @override
  List<Object> get props => [];
}

class GpsLocationAcquiring extends MapState {
  GpsLocationAcquiring(List<PlaceMarker> places) : super(places);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GpsLocationUpdated extends MapState {
  final LatLng currentGpsPosition;
  final Marker gpsMarker;

  GpsLocationUpdated(
      {@required this.currentGpsPosition,
      @required visitedPlaces,
      @required this.gpsMarker})
      : super(visitedPlaces);

  @override
  // TODO: implement props
  List<Object> get props => [currentGpsPosition, gpsMarker];
}

class GpsLocationFailed extends MapState {
  GpsLocationFailed(List<PlaceMarker> places) : super(places);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//endregion
