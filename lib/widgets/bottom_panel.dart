import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel_state.dart';
import 'package:sgcovidmapper/widgets/reverse_geocode_location_panel.dart';
import 'package:sgcovidmapper/widgets/widgets.dart';

class BottomPanel extends StatelessWidget {
  final BottomPanelState state;
  final ScrollController scrollController;

  const BottomPanel({this.state, this.scrollController});

  @override
  Widget build(BuildContext context) {
    if (state is BottomPanelOpening) {
      BottomPanelStateData data = state.data;
      if (BlocProvider.of<BottomPanelBloc>(context).panelType ==
          PanelType.search) return SearchPanel();
      if (BlocProvider.of<BottomPanelBloc>(context).panelType ==
              PanelType.covidPlaces &&
          data is PlacePanelData)
        return PlacesPanel(
          markers: data.markers,
          scrollController: scrollController,
        );

      if (data is GeocodePanelData &&
          BlocProvider.of<BottomPanelBloc>(context).panelType ==
              PanelType.geocode) {
        print(data.geocode.results.length);
        return ReverseGeocodeLocationPanel(
          data: data.geocode,
        );
      }
    }

    if (state is BottomPanelOpened) {
      BottomPanelStateData data = state.data;
      if (data is PlacePanelData &&
          BlocProvider.of<BottomPanelBloc>(context).panelType ==
              PanelType.covidPlaces)
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
