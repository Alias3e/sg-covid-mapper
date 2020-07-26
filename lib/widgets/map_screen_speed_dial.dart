import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_bloc.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_state.dart';
import 'package:sgcovidmapper/screens/timeline_screen.dart';
import 'package:sgcovidmapper/util/constants.dart';

class MapScreenSpeedDial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      animatedIcon:
          BlocProvider.of<MapBloc>(context).state is GpsLocationAcquiring
              ? null
              : AnimatedIcons.menu_close,
      overlayColor: Colors.black,
      curve: Curves.bounceInOut,
      children: [
        SpeedDialChild(
            child: Icon(Icons.gps_fixed),
            backgroundColor: Colors.blue,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => BlocProvider.of<MapBloc>(context).add(GetGPS())),
        SpeedDialChild(
            backgroundColor: Colors.blue,
            child: OpenContainer(
              closedColor: Colors.red,
              closedElevation: 6.0,
              closedShape: CircleBorder(),
              closedBuilder: (BuildContext context, void Function() action) {
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
    );
  }
}
