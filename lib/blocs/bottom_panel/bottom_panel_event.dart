import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';

class BottomPanelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class OnBottomPanelClosed extends BottomPanelEvent {}

class BottomPanelCollapsed extends BottomPanelEvent {}

class SearchPanelOpenAnimationStarted extends BottomPanelEvent {}

class GeocodePanelOpenAnimationStarted extends BottomPanelEvent {
  final ReverseGeocode geocode;

  GeocodePanelOpenAnimationStarted(this.geocode);

  @override
  List<Object> get props => [geocode];
}

class SearchPanelOpened extends BottomPanelEvent {}

class PanelPositionChanged extends BottomPanelEvent {
  final double position;
  final BottomPanelStateData data;

  PanelPositionChanged({@required this.position, @required this.data});

  @override
  List<Object> get props => [position, data];
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

  CheckInPanelSwitched({@required this.result});

  @override
  List<Object> get props => [result];
}

class SearchPanelSwitched extends BottomPanelEvent {}

class ReverseGeocodePanelSwitched extends BottomPanelEvent {}
