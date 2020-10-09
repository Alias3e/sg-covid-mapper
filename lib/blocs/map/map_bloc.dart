import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/util/constants.dart';

import 'map.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  final CovidPlacesRepository covidPlacesRepository;
  final GpsBloc gpsBloc;
  final ReverseGeocodeBloc reverseGeocodeBloc;
  List<Marker> _myPlaces = [];
  List<Marker> _nearbyPlaces = [];
  StreamSubscription _subscription;
  StreamSubscription _settingsSubscription;
  Marker _lastGpsLocation;

  MapBloc({
    @required this.covidPlacesRepository,
    @required this.gpsBloc,
    @required this.reverseGeocodeBloc,
  }) {
    assert(covidPlacesRepository != null);
    assert(gpsBloc != null);
    assert(reverseGeocodeBloc != null);
    subscribe();
    gpsBloc.listen((state) {
      if (state is GpsAcquired)
        add(OnGpsLocationAcquired(location: state.location));
    });

    reverseGeocodeBloc.listen((state) async {
      if (state is GeocodingCompleted) {
        add(OnNearbyLocationRetrieved(state.result.results));
      }
    });
  }

  Future<void> subscribe() async {
    _subscription = covidPlacesRepository.placeMarkers
        .listen((event) => add(HasPlacesData(event)));
  }

  @override
  MapState get initialState => PlacesLoading();

  @override
  Stream<MapState> mapEventToState(MapEvent event) async* {
    if (event is HasPlacesData) {
      covidPlacesRepository.placeMarkersCached = event.visitedPlaces;
      if (event.visitedPlaces.length > 0)
        yield MapUpdated(
            covidPlaces: event.visitedPlaces, nearbyPlaces: _myPlaces);
      else
        yield NoPlacesToDisplay([], _myPlaces);
    }

    if (event is CenterOnLocation) {
      _myPlaces.clear();
      _updatePlaceMarkers(
          [_makeMarker(event.location.latitude, event.location.longitude)]);

      yield MapViewBoundsChanged(
        mapCenter: LatLng(event.location.latitude, event.location.longitude),
        nearbyPlaces: _myPlaces,
        covidPlaces: covidPlacesRepository.placeMarkersCached,
      );
    }

    if (event is OnGpsLocationAcquired) {
      _lastGpsLocation = _makeMarker(
          event.location.latitude, event.location.longitude,
          iconData: FontAwesomeIcons.dotCircle, color: AppColors.kColorAccent);
      _updatePlaceMarkers([_lastGpsLocation]);
    }

    if (event is OnNearbyLocationRetrieved) {
      for (CommonOneMapModel model in event.locations) {
        _nearbyPlaces.add(_makeMarker(model.latitude, model.longitude,
            color: AppColors.kColorPrimary,
            iconData: FontAwesomeIcons.solidCircle,
            align: AnchorAlign.center,
            size: 15.0));
      }
    }

    if (event is DisplayUserAndNearbyMarkers) {
      _updatePlaceMarkers([_lastGpsLocation]);
      yield MapViewBoundsChanged(
        mapCenter: LatLng(
            _lastGpsLocation.point.latitude, _lastGpsLocation.point.longitude),
        nearbyPlaces: _myPlaces..addAll(_nearbyPlaces),
        covidPlaces: covidPlacesRepository.placeMarkersCached,
        zoomLevel: MapConstants.maxZoom - 0.5,
      );
    }

    if (event is GeoCodeLocationSelected) {
      List<Marker> newPlaces = [
        _lastGpsLocation,
        _makeMarker(event.latitude, event.longitude)
      ];
      _myPlaces = newPlaces..insertAll(0, _nearbyPlaces);
      yield MapUpdated(
          covidPlaces: covidPlacesRepository.placeMarkersCached,
          nearbyPlaces: _myPlaces);
    }

    if (event is ClearOneMapPlacesMarker) {
      _myPlaces = List<Marker>();
      yield MapUpdated(
          covidPlaces: covidPlacesRepository.placeMarkersCached,
          nearbyPlaces: []);
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    _settingsSubscription?.cancel();
    gpsBloc.close();
    reverseGeocodeBloc.close();
    return super.close();
  }

  void _updatePlaceMarkers(List<Marker> markers) {
    _myPlaces.addAll(markers);
  }

  Marker _makeMarker(double latitude, double longitude,
      {IconData iconData,
      Color color,
      AnchorAlign align = AnchorAlign.top,
      double size = 25}) {
    return Marker(
      point: LatLng(latitude, longitude),
      anchorPos: AnchorPos.align(align),
      height: size,
      width: size,
      builder: (context) => Center(
        child: FaIcon(
          iconData == null ? FontAwesomeIcons.mapMarkerAlt : iconData,
          color: color == null ? AppColors.kColorAccent : color,
          size: size,
        ),
      ),
    );
  }
}
