import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final VisitedPlaceRepository visitedPlaceRepository;
  final GpsRepository gpsRepository;
  List<Marker> _myPlaces = [];
  StreamSubscription _subscription;

  MapBloc(
      {@required this.visitedPlaceRepository, @required this.gpsRepository}) {
    assert(visitedPlaceRepository != null);
    assert(gpsRepository != null);
    _subscription = visitedPlaceRepository.placeMarkers
        .listen((event) => add(HasPlacesData(event)));
  }

  @override
  MapState get initialState => PlacesLoading();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is HasPlacesData) {
      visitedPlaceRepository.cached = event.visitedPlaces;
      yield MapUpdated(
          covidPlaces: event.visitedPlaces, nearbyPlaces: _myPlaces);
    }

    if (event is CenterOnLocation) {
      Marker marker = Marker(
          point: LatLng(event.location.latitude, event.location.longitude),
          builder: (context) => FaIcon(
                FontAwesomeIcons.mapMarkerAlt,
                color: Colors.amber,
                size: 50,
              ));
      updatePlaceMarkers([marker]);
      yield MapViewBoundsChanged(
        mapCenter: LatLng(event.location.latitude, event.location.longitude),
        nearbyPlaces: _myPlaces,
        covidPlaces: visitedPlaceRepository.cached,
      );
    }

    if (event is GetGPS) {
      yield GpsLocationAcquiring(
          covidPlaces: visitedPlaceRepository.cached, nearbyPlaces: _myPlaces);
      try {
        Position position = await gpsRepository.getCurrentLocation();
        Marker gpsMarker = Marker(
            point: LatLng(position.latitude, position.longitude),
            builder: (context) => FaIcon(
                  FontAwesomeIcons.mapMarkerAlt,
                  color: Colors.amber,
                  size: 50,
                ));
        updatePlaceMarkers([gpsMarker]);
        yield MapViewBoundsChanged(
          mapCenter: LatLng(position.latitude, position.longitude),
          nearbyPlaces: _myPlaces,
          covidPlaces: visitedPlaceRepository.cached,
        );
//        yield GpsLocationUpdated(
//          currentGpsPosition: LatLng(position.latitude, position.longitude),
//          covidPlaces: visitedPlaceRepository.cached,
//          gpsMarker: Marker(
//              point: LatLng(position.latitude, position.longitude),
//              builder: (context) => FaIcon(
//                    FontAwesomeIcons.mapMarkerAlt,
//                    color: Colors.amber,
//                    size: 50,
//                  )),
//          nearbyPlaces: myPlaces,
//        );
      } catch (exception) {
        yield GpsLocationFailed(
            covidPlaces: visitedPlaceRepository.cached,
            nearbyPlaces: _myPlaces);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }

  void updatePlaceMarkers(List<Marker> markers) {
    _myPlaces.clear();
    _myPlaces.addAll(markers);
  }
}
