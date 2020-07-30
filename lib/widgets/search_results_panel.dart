import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_event.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/blocs/search_box/search_box.dart';
import 'package:sgcovidmapper/models/one_map/one_map_search_result.dart';

class SearchResultsPanel extends StatelessWidget {
  final SearchResultLoaded searchState;

  const SearchResultsPanel({@required this.searchState});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: EdgeInsets.only(top: 60),
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: searchState.result != null ? searchState.result.count : 0,
        itemBuilder: (BuildContext context, int index) {
          OneMapSearchResult result = searchState.result.results[index];
          return AnimatedContainer(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              border: searchState.selected == index
                  ? Border.all(color: Colors.teal)
                  : null,
              borderRadius: BorderRadius.all(Radius.circular(12.0)),
            ),
            duration: Duration(milliseconds: 500),
            child: ListTile(
              title: Text('${result.searchValue}'),
              subtitle: Text('${result.address}'),
              trailing: IconButton(
                icon: Icon(FontAwesomeIcons.signInAlt),
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  BlocProvider.of<BottomPanelBloc>(context).add(
                      CheckInPanelSwitched(
                          result: result, previousState: searchState));
                  BlocProvider.of<CheckPanelBloc>(context).add(
                      DisplayLocationCheckInPanel(
                          CheckInPanelData(result, DateTime.now())));
                  BlocProvider.of<SearchBoxBloc>(context)
                      .add(SearchBoxOpacityChanged(1));
                },
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                BlocProvider.of<MapBloc>(context).add(CenterOnLocation(
                    location: LatLng(result.latitude, result.longitude)));
                BlocProvider.of<SearchBloc>(context)
                    .add(SearchLocationTapped(index));
              },
            ),
          );
        },
      ),
    );
  }
}
