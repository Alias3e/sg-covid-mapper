import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';

abstract class BottomPanelStateData extends Equatable {}

class SearchPanelData extends BottomPanelStateData {
  final String searchVal;

  SearchPanelData({this.searchVal});
  @override
  List<Object> get props => [searchVal];
}

class PlacePanelData extends BottomPanelStateData {
  final List<PlaceMarker> markers;

  PlacePanelData(this.markers);

  @override
  List<Object> get props => [markers];
}

class GeocodePanelData extends BottomPanelStateData {
  final ReverseGeocode geocode;

  GeocodePanelData(this.geocode);

  @override
  List<Object> get props => [geocode];
}

class CheckInPanelData extends BottomPanelStateData {
  final CommonOneMapModel location;
  final DateTime dateTime;

  CheckInPanelData(this.location, this.dateTime);

  @override
  List<Object> get props => [location, dateTime];
}

abstract class BottomPanelState<T extends BottomPanelStateData>
    extends Equatable {
  final double maxHeight;
  final bool isDraggable;
  final T data;

  BottomPanelState(this.maxHeight, this.isDraggable, {this.data});

  @override
  List<Object> get props => [maxHeight, isDraggable, data];
}

class BottomPanelClosed extends BottomPanelState {
  BottomPanelClosed({
    @required double maxHeight,
    @required bool isDraggable,
  }) : super(maxHeight, isDraggable);
}

class BottomPanelClosing extends BottomPanelState {
  BottomPanelClosing({
    @required double maxHeight,
    @required bool isDraggable,
  }) : super(maxHeight, isDraggable);
}

class BottomPanelOpening<T extends BottomPanelStateData>
    extends BottomPanelState<T> {
  BottomPanelOpening(
      {@required double maxHeight,
      @required bool isDraggable,
      BottomPanelStateData data})
      : super(maxHeight, isDraggable, data: data);
}

class BottomPanelOpened<T extends BottomPanelStateData>
    extends BottomPanelState<T> {
  BottomPanelOpened({
    @required double maxHeight,
    @required bool isDraggable,
    @required BottomPanelStateData data,
  }) : super(maxHeight, isDraggable, data: data);
}

class BottomPanelContentChanged<T extends BottomPanelStateData>
    extends BottomPanelState<T> {
  BottomPanelContentChanged(
      {@required BottomPanelStateData data, @required double maxHeight})
      : super(maxHeight, false, data: data);

  List<Object> get props => [data];
}

class PanelPositionUpdated<T extends BottomPanelStateData>
    extends BottomPanelState<T> {
  final double position;

  PanelPositionUpdated(
      {@required double maxHeight,
      @required bool isDraggable,
      @required this.position,
      @required BottomPanelStateData data})
      : super(maxHeight, isDraggable, data: data);

  List<Object> get props => [position];
}
