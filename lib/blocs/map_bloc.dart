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
      yield PlacesUpdated(event.visitedPlaces);
    }

    if (event is GetGPS) {
      yield GpsLocationAcquiring(visitedPlaceRepository.cached);
      try {
        Position position = await gpsRepository.getCurrentLocation();
        yield GpsLocationUpdated(
            currentGpsPosition: LatLng(position.latitude, position.longitude),
            visitedPlaces: visitedPlaceRepository.cached,
            gpsMarker: Marker(
                point: LatLng(position.latitude, position.longitude),
                builder: (context) => FaIcon(
                      FontAwesomeIcons.mapMarkerAlt,
                      color: Colors.amber,
                      size: 50,
                    )));
      } catch (exception) {
        yield GpsLocationFailed(visitedPlaceRepository.cached);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
