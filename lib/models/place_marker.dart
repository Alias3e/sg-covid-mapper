import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';

class PlaceMarker extends Marker with EquatableMixin {
  final String title;
  final String subLocation;
  final Timestamp startDate;
  final Timestamp endDate;

  PlaceMarker(
      {@required this.title,
      @required this.subLocation,
      @required this.startDate,
      @required this.endDate,
      @required point,
      @required builder})
      : super(
          point: point,
          builder: builder,
        );

  static PlaceMarker fromFireStoreSnapshot(DocumentSnapshot snapshot) {
    return PlaceMarker(
      title: snapshot['title'],
      subLocation: snapshot['sub_location'],
      startDate: snapshot['start_date'],
      endDate: snapshot['end_date'],
      point: LatLng(snapshot['geo'].latitude, snapshot['geo'].longitude),
      builder: (BuildContext context) => FaIcon(
        FontAwesomeIcons.virus,
        color: Colors.teal,
      ),
    );
  }

  @override
  List<Object> get props => [title, point.longitude, point.longitude];
}
