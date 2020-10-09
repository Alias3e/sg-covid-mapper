import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/models/models.dart';

import 'bottom_panel.dart';

enum PanelType { none, covidPlaces, search, geocode, log }

class BottomPanelBloc extends Bloc<BottomPanelEvent, BottomPanelState> {
  List<PlaceMarker> _currentMarkers = [];
  final ReverseGeocodeBloc _reverseGeocodeBloc;
  PanelType _panelType = PanelType.none;

  PanelType get panelType => _panelType;

  BottomPanelBloc(this._reverseGeocodeBloc) {
    _reverseGeocodeBloc.listen((state) {
      if (state is GeocodingCompleted)
        add(GeocodePanelOpenAnimationStarted(state.result));
    });
  }

  @override
  BottomPanelState get initialState =>
      BottomPanelClosed(isDraggable: false, maxHeight: 0.0);

  @override
  Stream<BottomPanelState> mapEventToState(BottomPanelEvent event) async* {
    if (event is BottomPanelCollapsed) {
      _panelType = PanelType.none;
      yield BottomPanelClosing(
        maxHeight: 0.0,
        isDraggable: false,
      );
    }

    if (event is SearchPanelOpenAnimationStarted) {
      _panelType = PanelType.search;
      yield BottomPanelOpening(
          maxHeight: 0.65, isDraggable: false, data: SearchPanelData());
    }

    if (event is GeocodePanelOpenAnimationStarted) {
      _panelType = PanelType.geocode;
      yield BottomPanelOpening(
          maxHeight: 0.65,
          isDraggable: false,
          data: GeocodePanelData(event.geocode));
    }

    if (event is PlacePanelOpened) {
      _panelType = PanelType.covidPlaces;
      yield BottomPanelOpened<PlacePanelData>(
          maxHeight: 0.4,
          isDraggable: true,
          data: PlacePanelData(_currentMarkers));
    }

    if (event is CheckInPanelSwitched) {
      _panelType = PanelType.log;
      yield BottomPanelContentChanged(
          maxHeight: 1, data: CheckInPanelData(event.result, DateTime.now()));
    }

    if (event is SearchPanelSwitched) {
      _panelType = PanelType.search;
      yield BottomPanelContentChanged(maxHeight: 1.0, data: SearchPanelData());
    }

    if (event is ReverseGeocodePanelSwitched) {
      _panelType = PanelType.geocode;
      yield BottomPanelContentChanged(
          maxHeight: 1.0, data: GeocodePanelData(null));
    }

    if (event is PlacePanelDisplayed) {
      _panelType = PanelType.covidPlaces;
      _currentMarkers = event.markers;
      yield BottomPanelOpening(
        maxHeight: 0.4,
        isDraggable: true,
        data: PlacePanelData(event.markers),
      );
    }

    if (event is OnBottomPanelClosed) {
      yield BottomPanelClosed(isDraggable: false, maxHeight: 0.0);
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
