import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/map_marker.dart';

class VisitedPlace extends Equatable with MapMarker {
  // Title/name of the visited place.
  final String title;
  // Geolocation of the place, in latitude and longitude.
  final GeoPoint geo;
  // The start date time when the place was visited by the case.
  final Timestamp startDate;
  // the end date time when the place was visited by the case.
  final Timestamp endDate;

  const VisitedPlace({this.title, this.geo, this.startDate, this.endDate});

  static VisitedPlace fromFireStoreSnapshot(DocumentSnapshot snapshot) {
    return VisitedPlace(
        title: snapshot['title'],
        geo: snapshot['geo'],
        startDate: snapshot['start_date'],
        endDate: snapshot['end_date']);
  }

  @override
  List<Object> get props => [title, geo, startDate, endDate];

  @override
  Marker toMarker() {
    return Marker(
      point: LatLng(geo.latitude, geo.longitude),
      builder: (BuildContext context) => FaIcon(
        FontAwesomeIcons.virus,
        color: Colors.teal,
      ),
    );
  }
}
