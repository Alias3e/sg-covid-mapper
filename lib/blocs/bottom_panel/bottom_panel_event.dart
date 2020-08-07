import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/blocs/search/search_state.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';

class BottomPanelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BottomPanelCollapsed extends BottomPanelEvent {}

class SearchPanelOpenAnimationStarted extends BottomPanelEvent {}

class GeocodePanelOpenAnimationStarted extends BottomPanelEvent {
  final ReverseGeocode geocode;

  GeocodePanelOpenAnimationStarted(this.geocode);

  @override
  List<Object> get props => [geocode];
}

class SearchPanelOpened extends BottomPanelEvent {}

class PlacePanelDragged extends BottomPanelEvent {
  final double position;

  PlacePanelDragged({this.position});

  @override
  List<Object> get props => [position];
}

class PlacePanelDisplayed extends BottomPanelEvent {
  final List<PlaceMarker> markers;

  PlacePanelDisplayed(this.markers);

  @override
  List<Object> get props => [markers];
}

class PlacePanelOpened extends BottomPanelEvent {}

class CheckInPanelSwitched extends BottomPanelEvent {
  final CommonOneMapModel result;
  final SearchResultLoaded previousState;

  CheckInPanelSwitched({@required this.result, @required this.previousState});

  @override
  List<Object> get props => [result, previousState];
}

class SearchPanelSwitched extends BottomPanelEvent {}
