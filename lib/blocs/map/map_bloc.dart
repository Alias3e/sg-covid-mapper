import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/gps_repository.dart';

import 'map.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final CovidPlacesRepository covidPlacesRepository;
  final GpsRepository gpsRepository;
  List<Marker> _myPlaces = [];
  StreamSubscription _subscription;
  StreamSubscription _settingsSubscription;

  MapBloc(
      {@required this.covidPlacesRepository, @required this.gpsRepository}) {
    assert(covidPlacesRepository != null);
    assert(gpsRepository != null);
    subscribe();
  }

  Future<void> subscribe() async {
    await covidPlacesRepository.init();
    _subscription = covidPlacesRepository.placeMarkers
        .listen((event) => add(HasPlacesData(event)));
  }

  @override
  MapState get initialState => PlacesLoading();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is HasPlacesData) {
      covidPlacesRepository.placeMarkersCached = event.visitedPlaces;
      yield MapUpdated(
          covidPlaces: event.visitedPlaces, nearbyPlaces: _myPlaces);
    }

    if (event is CenterOnLocation) {
      _updatePlaceMarkers(
          [_makeMarker(event.location.latitude, event.location.longitude)]);
      yield MapViewBoundsChanged(
        mapCenter: LatLng(event.location.latitude, event.location.longitude),
        nearbyPlaces: _myPlaces,
        covidPlaces: covidPlacesRepository.placeMarkersCached,
      );
    }

    if (event is GetGPS) {
      yield GpsLocationAcquiring(
          covidPlaces: covidPlacesRepository.placeMarkersCached,
          nearbyPlaces: _myPlaces);
      try {
        Position position = await gpsRepository.getCurrentLocation();
        _updatePlaceMarkers(
            [_makeMarker(position.latitude, position.longitude)]);
        yield GPSAcquired(
          mapCenter: LatLng(position.latitude, position.longitude),
          nearbyPlaces: _myPlaces,
          covidPlaces: covidPlacesRepository.placeMarkersCached,
        );
      } catch (exception) {
        yield GpsLocationFailed(
            covidPlaces: covidPlacesRepository.placeMarkersCached,
            nearbyPlaces: _myPlaces);
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _settingsSubscription?.cancel();
    return super.close();
  }

  void _updatePlaceMarkers(List<Marker> markers) {
    _myPlaces.clear();
    _myPlaces.addAll(markers);
  }

  Marker _makeMarker(double latitude, double longitude) {
    return Marker(
      point: LatLng(latitude, longitude),
      anchorPos: AnchorPos.align(AnchorAlign.top),
      height: 50,
      width: 50,
      builder: (context) => FaIcon(
        FontAwesomeIcons.mapMarkerAlt,
        color: Colors.amber,
        size: 50,
      ),
    );
  }
}
