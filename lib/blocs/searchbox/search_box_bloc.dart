import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_state.dart';
import 'package:sgcovidmapper/blocs/searchbox/search_box_event.dart';
import 'package:sgcovidmapper/blocs/searchbox/search_box_state.dart';

class SearchBoxBloc extends Bloc<SearchBoxEvent, SearchBoxState> {
  final BottomPanelBloc _bottomPanelBloc;
  StreamSubscription bottomPanelSubscription;

  SearchBoxBloc(this._bottomPanelBloc) {
    assert(_bottomPanelBloc != null);
    _bottomPanelBloc.listen((state) {
      if (state is BottomPanelOpened && state.data is PlacePanelData)
        add(SearchBoxOpacityChanged(1.0));
      if (state is PlacePanelPositionChanging)
        add(SearchBoxOpacityChanged(state.position));
    });
  }

  @override
  SearchBoxState get initialState => SearchBoxFullyOpaque();

  @override
  Stream<SearchBoxState> mapEventToState(SearchBoxEvent event) async* {
    if (event is SearchBoxOpacityChanged) {
      print('event opacity is ${event.opacity}');
      yield SearchBoxOpacityUpdating(event.opacity);
    }
  }

  @override
  Future<void> close() {
    bottomPanelSubscription?.cancel();
    return super.close();
  }
}
