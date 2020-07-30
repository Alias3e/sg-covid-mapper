import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/blocs/search/search_state.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/models/one_map/one_map_search_result.dart';

class BottomPanelEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class BottomPanelCollapsed extends BottomPanelEvent {}

class SearchPanelOpenAnimationStarted extends BottomPanelEvent {}

class SearchPanelOpened extends BottomPanelEvent {}

class GPSPanelOpened extends BottomPanelEvent {}

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
  final OneMapSearchResult result;
  final SearchResultLoaded previousState;

  CheckInPanelSwitched({@required this.result, @required this.previousState});

  @override
  List<Object> get props => [result, previousState];
}

class SearchPanelSwitched extends BottomPanelEvent {}
