import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';

class UpdateOpacityBloc extends Bloc<UpdateOpacityEvent, UpdateOpacityState> {
  final BottomPanelBloc _bottomPanelBloc;
  StreamSubscription bottomPanelSubscription;

  UpdateOpacityBloc(this._bottomPanelBloc) {
    assert(_bottomPanelBloc != null);
    _bottomPanelBloc.listen((state) {
//      if (state is BottomPanelOpened && state.data is PlacePanelData)
//        add(OpacityChanged(1.0));
//      if (state is BottomPanelOpening && state.data is SearchPanelData)
//        add(SpeedDialOpacityChanged(1.0));
//      if (state is BottomPanelOpening && state.data is GeocodePanelData)
//        add(OpacityChanged(1.0));
      if (state is PanelPositionUpdated<BottomPanelStateData>) {
        if (state.data is! SearchPanelData)
          add(OpacityChanged(state.position));
        else
          add(SpeedDialOpacityChanged(state.position));

//        if (state.data is PlacePanelData) add(OpacityChanged(state.position));
//        if (state.data is SearchPanelData)
//          add(SpeedDialOpacityChanged(state.position));
//        if (state.data is GeocodePanelData)
//          add(SearchBoxOpacityChanged(state.position));
      }
    });
  }

  @override
  UpdateOpacityState get initialState => WidgetFullyOpaque();

  @override
  Stream<UpdateOpacityState> mapEventToState(UpdateOpacityEvent event) async* {
    if (event is OpacityChanged &&
        event is! SpeedDialOpacityChanged &&
        event is! SearchBoxOpacityChanged) {
      yield OpacityUpdating(event.opacity);
    }

//    if (event is OpacityChanged) yield SpeedDialOpacityUpdating(event.opacity);

    if (event is SpeedDialOpacityChanged)
      yield SpeedDialOpacityUpdating(event.opacity);

    if (event is SearchBoxOpacityChanged)
      yield SearchBoxOpacityUpdating(event.opacity);
  }

  @override
  Future<void> close() {
    bottomPanelSubscription?.cancel();
    return super.close();
  }
}
