import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_bloc.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_event.dart';
import 'package:sgcovidmapper/blocs/keyboard_visibility/keyboard_visibility.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/util/constants.dart';

class SearchResultsPanel extends StatelessWidget {
  final SearchResultLoaded searchState;

  const SearchResultsPanel({@required this.searchState});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<KeyboardVisibilityBloc, KeyboardVisibilityState>(
      builder: (BuildContext context, state) => SafeArea(
        minimum: EdgeInsets.only(top: state is KeyboardVisible ? 60 : 0),
        child: Container(
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount:
                searchState.result != null ? searchState.result.count : 0,
            itemBuilder: (BuildContext context, int index) {
              CommonOneMapModel result = searchState.result.results[index];
              return ListTile(
                title: AnimatedDefaultTextStyle(
                  style: searchState.selected != index
                      ? Theme.of(context).textTheme.subtitle1
                      : Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w600),
                  duration: Duration(milliseconds: 200),
                  child: Text(result.title),
                ),
                subtitle: AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: searchState.selected != index
                        ? Theme.of(context).textTheme.bodyText2.copyWith(
                            color: Theme.of(context).textTheme.caption.color)
                        : Theme.of(context)
                            .textTheme
                            .bodyText2
                            .copyWith(color: AppColors.kColorPrimary[300]),
                    child: Text(result.subtitle)),
                trailing: IconButton(
                  icon: Icon(
                    FontAwesomeIcons.signInAlt,
                    color: Theme.of(context).accentColor,
                  ),
                  onPressed: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    BlocProvider.of<MapBloc>(context).add(CenterOnLocation(
                        location: LatLng(result.latitude, result.longitude)));
                    BlocProvider.of<BottomPanelBloc>(context)
                        .add(CheckInPanelSwitched(result: result));
                    BlocProvider.of<CheckPanelBloc>(context).add(
                        DisplayLocationCheckInPanel(
                            CheckInPanelData(result, DateTime.now())));
                    BlocProvider.of<UpdateOpacityBloc>(context)
                        .add(OpacityChanged(1));
                  },
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  BlocProvider.of<MapBloc>(context).add(CenterOnLocation(
                      location: LatLng(result.latitude, result.longitude)));
                  BlocProvider.of<SearchBloc>(context)
                      .add(SearchLocationTapped(index));
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
