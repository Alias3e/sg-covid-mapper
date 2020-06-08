import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    _subscription = visitedPlaceRepository.visitedPlaces
        .listen((event) => add(HasPlacesData(event)));
  }

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is HasPlacesData) {
//      List<VisitedPlace> places = repository.visitedPlaces;
      visitedPlaceRepository.cached = event.visitedPlaces;
      yield PlacesUpdated(event.visitedPlaces);
    }

    if (event is GetGPS) {
      yield GpsLocationAcquiring(visitedPlaceRepository.cached);
      Position position = await gpsRepository.getCurrentLocation();
      yield GpsLocationUpdated(
          currentGpsPosition: LatLng(position.latitude, position.longitude),
          visitedPlaces: visitedPlaceRepository.cached);
    }
  }

  @override
  MapState get initialState => PlacesLoading();

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
