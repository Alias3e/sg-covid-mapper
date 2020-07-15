import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_event.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_state.dart';
import 'package:sgcovidmapper/models/models.dart';

class BottomPanelBloc extends Bloc<BottomPanelEvent, BottomPanelState> {
  List<PlaceMarker> _currentMarkers = [];

  @override
  BottomPanelState get initialState => BottomPanelClosing(
        maxHeight: 0.0,
        isDraggable: false,
      );

  @override
  Stream<BottomPanelState> mapEventToState(BottomPanelEvent event) async* {
    if (event is BottomPanelCollapsed)
      yield BottomPanelClosing(
        maxHeight: 0.0,
        isDraggable: false,
      );

    if (event is SearchPanelOpenAnimationStarted)
      yield BottomPanelOpening(
          maxHeight: 0.65, isDraggable: false, data: SearchPanelData());

    if (event is PlacePanelOpened) {
      yield BottomPanelOpened<PlacePanelData>(
          maxHeight: 0.4,
          isDraggable: true,
          data: PlacePanelData(_currentMarkers));
    }

    if (event is CheckInPanelSwitched) {
      yield BottomPanelContentChanged(
          data: CheckInPanelData(event.result, DateTime.now()));
    }

    if (event is SearchPanelSwitched) {
      yield BottomPanelContentChanged(data: SearchPanelData());
    }

    if (event is PlacePanelDisplayed) {
      _currentMarkers = event.markers;
      yield BottomPanelOpening(
        maxHeight: 0.4,
        isDraggable: true,
        data: PlacePanelData(event.markers),
      );
    }

    if (event is PlacePanelDragged) {
      yield PlacePanelPositionChanging(
        maxHeight: 0.4,
        isDraggable: true,
        position: event.position,
      );
    }
  }
}
