import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/map_state.dart';
import 'package:sgcovidmapper/util/constants.dart';

// TODO Deprecated, to be removed.
class GpsFloatingActionButton extends StatelessWidget {
  final MapState state;

  const GpsFloatingActionButton({
    @required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: state is GpsLocationAcquiring
          ? SpinKitDualRing(
              key: Keys.kKeyFABSpinner,
              color: Colors.white,
              size: 35.0,
              lineWidth: 4.0,
            )
          : Icon(Icons.gps_fixed),
      onPressed: () {
        BlocProvider.of<MapBloc>(context).add(GetGPS());
      },
    );
  }
}
