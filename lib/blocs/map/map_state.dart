//region Map States
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/place_marker.dart';

abstract class MapState extends Equatable {
  final List<PlaceMarker> covidPlaces;
  final List<Marker> nearbyPlaces;
  const MapState(this.covidPlaces, this.nearbyPlaces);
}

class PlacesLoading extends MapState {
  PlacesLoading() : super([], []);

  @override
  List<Object> get props => [];
}

class MapUpdated extends MapState {
  const MapUpdated({List<PlaceMarker> covidPlaces, List<Marker> nearbyPlaces})
      : super(covidPlaces, nearbyPlaces);

  @override
  List<Object> get props {
    List<Object> props = [];
    return props..addAll(covidPlaces)..addAll(nearbyPlaces);
  }
}

class PlacesError extends MapState {
  const PlacesError(List<PlaceMarker> covidPlaces, List<Marker> nearbyPlaces)
      : super(covidPlaces, nearbyPlaces);

  @override
  List<Object> get props => [];
}

class GpsLocationAcquiring extends MapState {
  const GpsLocationAcquiring(
      {List<PlaceMarker> covidPlaces, List<Marker> nearbyPlaces})
      : super(covidPlaces, nearbyPlaces);

  @override
  List<Object> get props => [];
}

class GPSAcquired extends MapState {
  final LatLng mapCenter;
  const GPSAcquired(
      {@required this.mapCenter,
      @required List<PlaceMarker> covidPlaces,
      @required List<Marker> nearbyPlaces})
      : super(covidPlaces, nearbyPlaces);

  @override
  List<Object> get props => [mapCenter];
}

class MapViewBoundsChanged extends MapState {
  final LatLng mapCenter;

  const MapViewBoundsChanged({
    @required this.mapCenter,
    @required List<PlaceMarker> covidPlaces,
    @required List<Marker> nearbyPlaces,
  }) : super(covidPlaces, nearbyPlaces);

  @override
  // TODO: implement props
  List<Object> get props => [mapCenter];
}

class GpsLocationFailed extends MapState {
  const GpsLocationFailed(
      {List<PlaceMarker> covidPlaces, List<Marker> nearbyPlaces})
      : super(covidPlaces, nearbyPlaces);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

//endregion
