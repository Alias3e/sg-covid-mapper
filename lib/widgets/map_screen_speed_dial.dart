import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/reverse_geocode/reverse_geocode.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/screens/timeline_screen.dart';
import 'package:sgcovidmapper/util/constants.dart';

class MapScreenSpeedDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpdateOpacityBloc, UpdateOpacityState>(
      condition: (previous, current) => current is! SearchBoxOpacityUpdating,
      builder: (BuildContext context, UpdateOpacityState state) => Visibility(
        visible: state.opacity != 0,
        child: AnimatedOpacity(
          opacity: state.opacity,
          duration: Duration(milliseconds: 250),
          child: BlocBuilder<ReverseGeocodeBloc, ReverseGeocodeState>(
            builder: (BuildContext context, state) => SpeedDial(
              animatedIcon: state is GeocodingInProgress
                  ? null
                  : AnimatedIcons.menu_close,
              overlayColor: Colors.black,
              curve: Curves.bounceInOut,
              children: [
                SpeedDialChild(
                    child: Icon(Icons.gps_fixed),
                    backgroundColor: Colors.blue,
                    label: 'Log your visit to a nearby location',
                    onTap: () =>
                        BlocProvider.of<MapBloc>(context).add(GetGPS())),
                SpeedDialChild(
                    backgroundColor: Colors.blue,
                    label: 'Display locations in a timeline',
                    child: OpenContainer(
                      closedColor: Colors.red,
                      closedElevation: 6.0,
                      closedShape: CircleBorder(),
                      closedBuilder:
                          (BuildContext context, void Function() action) {
                        return SizedBox(
                          child: Center(
                            child: Icon(
                              Icons.timeline,
                              color: Theme.of(context).colorScheme.onSecondary,
                            ),
                          ),
                        );
                      },
                      openBuilder: (BuildContext context,
                          void Function({Object returnValue}) action) {
                        return BlocBuilder<TimelineBloc, TimelineState>(
                          builder: (BuildContext context, TimelineState state) {
                            return state is TimelineLoaded
                                ? TimelineScreen(
                                    timelineModel: state.model,
                                  )
                                : Container(
                                    color: Colors.redAccent,
                                  );
                          },
                        );
                      },
                    ))
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
