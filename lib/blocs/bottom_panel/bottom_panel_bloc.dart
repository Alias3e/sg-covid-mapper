import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/models.dart';

import 'bottom_panel.dart';

class BottomPanelBloc extends Bloc<BottomPanelEvent, BottomPanelState> {
  List<PlaceMarker> _currentMarkers = [];
  final ReverseGeocodeBloc _reverseGeocodeBloc;

  BottomPanelBloc(this._reverseGeocodeBloc) {
    _reverseGeocodeBloc.listen((state) {
      if (state is GeocodingCompleted)
        add(GeocodePanelOpenAnimationStarted(state.result));
    });
  }

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

    if (event is GeocodePanelOpenAnimationStarted)
      yield BottomPanelOpening(
          maxHeight: 0.65,
          isDraggable: false,
          data: GeocodePanelData(event.geocode));

    if (event is PlacePanelOpened) {
      yield BottomPanelOpened<PlacePanelData>(
          maxHeight: 0.4,
          isDraggable: true,
          data: PlacePanelData(_currentMarkers));
    }

    if (event is CheckInPanelSwitched) {
      yield BottomPanelContentChanged(
          maxHeight: 0.65,
          data: CheckInPanelData(event.result, DateTime.now()));
    }

    if (event is SearchPanelSwitched) {
      yield BottomPanelContentChanged(maxHeight: 1.0, data: SearchPanelData());
    }

    if (event is PlacePanelDisplayed) {
      _currentMarkers = event.markers;
      yield BottomPanelOpening(
        maxHeight: 0.4,
        isDraggable: true,
        data: PlacePanelData(event.markers),
      );
    }

    if (event is PanelPositionChanged) {
      yield PanelPositionUpdated(
        maxHeight: 0.4,
        isDraggable: true,
        position: event.position,
        data: event.data,
      );
    }
  }

  @override
  Future<void> close() {
    _reverseGeocodeBloc.close();
    return super.close();
  }
}
