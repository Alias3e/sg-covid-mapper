import 'package:flutter/material.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_state.dart';
import 'package:sgcovidmapper/widgets/widgets.dart';

class BottomPanel extends StatelessWidget {
  final BottomPanelState state;
  final ScrollController scrollController;

  const BottomPanel({this.state, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (state is BottomPanelOpening) {
      BottomPanelStateData data = state.data;
      if (data is SearchPanelData) return SearchPanel();
      if (data is PlacePanelData)
        return PlacesPanel(
          markers: data.markers,
          scrollController: scrollController,
        );
    }

    if (state is BottomPanelOpened) {
      BottomPanelStateData data = state.data;
      if (data is PlacePanelData)
        return PlacesPanel(
          markers: data.markers,
          scrollController: scrollController,
        );
    }

    return Container(
      width: 0,
      height: 0,
    );
  }
}
