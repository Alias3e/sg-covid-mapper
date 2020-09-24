import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/screens/log_screen.dart';
import 'package:sgcovidmapper/screens/timeline_screen.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/open_container_speed_dial.dart';

class MapScreenSpeedDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateOpacityBloc, UpdateOpacityState>(
      condition: (previous, current) => current is! SearchBoxOpacityUpdating,
      builder: (BuildContext context, UpdateOpacityState state) => Visibility(
        visible: state.opacity != 0,
        child: AnimatedOpacity(
          opacity: state.opacity,
          duration: Duration(milliseconds: kAnimationDuration),
          child: BlocBuilder<ReverseGeocodeBloc, ReverseGeocodeState>(
            builder: (BuildContext context, state) => SpeedDial(
              onOpen: () => BlocProvider.of<SearchTextFieldBloc>(context)
                  .add(SearchTextFieldLoseFocus()),
              animatedIcon: state is GeocodingInProgress
                  ? null
                  : AnimatedIcons.menu_close,
              overlayColor: Theme.of(context).primaryColor,
              curve: Curves.linearToEaseOut,
              animationSpeed: 100,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.gps_fixed),
                    backgroundColor: Theme.of(context).accentColor,
                    labelWidget: LabelCard(
                      label: 'Log your visit to a nearby location',
                    ),
//                    labelBackgroundColor: Theme.of(context).accentColor,
//                    labelStyle: TextStyle(
//                        color: Colors.white, fontWeight: FontWeight.bold),
                    onTap: () =>
                        BlocProvider.of<GpsBloc>(context).add(GetGps())),
                SpeedDialChild(
                  labelWidget: LabelCard(
                    label: 'Log of places you visited',
                  ),
                  child: OpenContainerSpeedDial(
                      color: Theme.of(context).accentColor,
                      icon: FontAwesomeIcons.clipboard,
                      openBuilder: openLogScreen),
                ),
                SpeedDialChild(
                  labelWidget:
                      LabelCard(label: 'Display locations in a timeline'),
                  child: OpenContainerSpeedDial(
                      color: Theme.of(context).accentColor,
                      icon: Icons.timeline,
                      openBuilder: timelineWidget),
                ),
              ],
              child: SpinKitDualRing(
                key: Keys.kKeyFABSpinner,
                color: Colors.white,
                size: 20.0,
                lineWidth: 3.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LabelCard extends StatelessWidget {
  final String label;
  final Color labelColor;

  const LabelCard({@required this.label, this.labelColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      elevation: 4,
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Text(
          label,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Widget timelineWidget(
    BuildContext context, void Function({Object returnValue}) action) {
  return BlocBuilder<TimelineBloc, TimelineState>(
    builder: (BuildContext context, TimelineState state) {
      return state is TimelineLoaded
          ? TimelineScreen(
              timelineModel: state.model,
            )
          : Container(
              color: AppColors.kColorRed,
            );
    },
  );
}

Widget openLogScreen(
    BuildContext context, void Function({Object returnValue}) action) {
  return LogScreen();
}
