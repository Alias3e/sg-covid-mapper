import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/check/check_panel.dart';

class ReverseGeocodeLocationPanel extends StatefulWidget {
  final ReverseGeocode data;

  const ReverseGeocodeLocationPanel({this.data});

  @override
  _ReverseGeocodeLocationPanelState createState() =>
      _ReverseGeocodeLocationPanelState();
}

class _ReverseGeocodeLocationPanelState
    extends State<ReverseGeocodeLocationPanel> {
  int selected = -1;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomPanelBloc, BottomPanelState>(
      condition: (previous, current) => current is BottomPanelContentChanged,
      builder:
          (BuildContext context, BottomPanelState<BottomPanelStateData> state) {
        return widget.data.results.length > 0
            ? AnimatedSwitcher(
                duration: Duration(milliseconds: kAnimationDuration),
                child: state is BottomPanelContentChanged &&
                        BlocProvider.of<BottomPanelBloc>(context).panelType ==
                            PanelType.log
                    ? CheckPanel(
                        switchOutEvent: ReverseGeocodePanelSwitched(),
                      )
                    : ListView.separated(
                        itemCount: widget.data.results.length,
                        itemBuilder: (context, index) {
                          CommonOneMapModel model = widget.data.results[index];
                          return ListTile(
                            title: AnimatedDefaultTextStyle(
                              style: selected != index
                                  ? Theme.of(context).textTheme.subtitle1
                                  : Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.w600),
                              duration:
                                  Duration(milliseconds: kAnimationDuration),
                              child: Text(model.title),
                            ),
                            subtitle: AnimatedDefaultTextStyle(
                              duration:
                                  Duration(milliseconds: kAnimationDuration),
                              style: selected != index
                                  ? Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .color)
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyText2
                                      .copyWith(
                                          color: AppColors.kColorPrimary[300]),
                              child: Text(
                                model.subtitle,
                              ),
                            ),
                            trailing: IconButton(
                              icon: Icon(FontAwesomeIcons.signInAlt,
                                  color: Theme.of(context).accentColor),
                              onPressed: () {
                                BlocProvider.of<BottomPanelBloc>(context)
                                    .add(CheckInPanelSwitched(result: model));
                                BlocProvider.of<CheckPanelBloc>(context).add(
                                    DisplayLocationCheckInPanel(
                                        CheckInPanelData(
                                            model, DateTime.now())));
                              },
                            ),
                            onTap: () {
                              setState(() {
                                selected = index;
                              });
                              BlocProvider.of<MapBloc>(context).add(
                                  GeoCodeLocationSelected(
                                      latitude: model.latitude,
                                      longitude: model.longitude));
                            },
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(
                          color: Colors.black12,
                        ),
                      ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(
                    child: Text(
                      'No results found. Try searching for an location instead.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      BlocProvider.of<BottomPanelBloc>(context)
                          .add(BottomPanelCollapsed());
                      BlocProvider.of<SearchTextFieldBloc>(context)
                          .add(FocusSearchTextField());
                    },
                    child: Icon(
                      FontAwesomeIcons.searchLocation,
                      size: 80,
                      color: Theme.of(context).accentColor,
                    ),
                  ),
                ],
              );
      },
    );
  }
}
