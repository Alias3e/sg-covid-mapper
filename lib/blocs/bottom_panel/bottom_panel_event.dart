import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/models.dart';

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
