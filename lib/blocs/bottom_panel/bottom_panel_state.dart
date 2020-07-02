import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:sgcovidmapper/models/models.dart';

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

abstract class BottomPanelState<T extends BottomPanelStateData>
    extends Equatable {
  final double maxHeight;
  final bool isDraggable;
  final T data;

  BottomPanelState(this.maxHeight, this.isDraggable, {this.data});

  @override
  List<Object> get props => [maxHeight, isDraggable];
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

class PlacePanelPositionChanging extends BottomPanelState {
  final double position;

  PlacePanelPositionChanging({
    @required double maxHeight,
    @required bool isDraggable,
    @required this.position,
  }) : super(maxHeight, isDraggable);

  List<Object> get props => [position];
}
