import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
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
            child: Icon(Icons.favorite_border),
            backgroundColor: Colors.red,
            labelStyle: TextStyle(fontSize: 18.0),
            onTap: () => print('FIRST CHILD')),
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
