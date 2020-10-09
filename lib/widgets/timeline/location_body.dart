import 'package:flutter/material.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';

class LocationBody extends StatelessWidget {
  final LocationTimelineItem item;

  const LocationBody({this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              item.title,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          item.subtitle.isNotEmpty
              ? Text(
                  item.subtitle,
                  textAlign: TextAlign.justify,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                )
              : Container(
                  width: 0,
                  height: 0,
                ),
        ],
      ),
    );
  }
}
