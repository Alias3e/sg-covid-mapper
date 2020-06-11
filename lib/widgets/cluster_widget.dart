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
        gradient: RadialGradient(
          colors: <Color>[Colors.teal.shade200, Colors.teal],
        ),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          markers.length.toString(),
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
