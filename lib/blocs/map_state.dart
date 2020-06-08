//region Map States
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/models.dart';

abstract class MapState extends Equatable {
  final List<VisitedPlace> places;
  const MapState(this.places);

  List<Marker> get markers {
    return places.map<Marker>((place) => place.toMarker()).toList();
  }
}

class PlacesLoading extends MapState {
  PlacesLoading() : super([]);

  @override
  List<Object> get props => [];
}

class PlacesUpdated extends MapState {
  PlacesUpdated(List<VisitedPlace> places) : super(places);

  @override
  List<Object> get props => [places];
}

class PlacesError extends MapState {
  PlacesError(List<VisitedPlace> places) : super(places);

  @override
  List<Object> get props => [];
}

class GpsLocationAcquiring extends MapState {
  GpsLocationAcquiring(List<VisitedPlace> places) : super(places);

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GpsLocationUpdated extends MapState {
  final LatLng currentGpsPosition;

  GpsLocationUpdated(
      {@required this.currentGpsPosition, @required visitedPlaces})
      : super(visitedPlaces);

  List<Marker> get markers {
    Marker locationMarker = Marker(
      point: LatLng(currentGpsPosition.latitude, currentGpsPosition.longitude),
      builder: (context) => FaIcon(
        FontAwesomeIcons.mapMarkerAlt,
        color: Colors.amber,
      ),
    );

    List<Marker> markers = super.markers;
    markers.add(locationMarker);
    return markers;
  }

  @override
  List<Object> get props => [currentGpsPosition];
}
//endregion
