import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class ClusterWidget extends StatelessWidget {
  final List<Marker> markers;
  const ClusterWidget({
    this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          markers.length.toString(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: markers.length * 1.5 + 14.0,
            color: Theme.of(context).primaryColorLight,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
