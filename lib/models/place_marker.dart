import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/util/constants.dart';

class PlaceMarker extends Marker with EquatableMixin {
  final String title;
  final String subtitle;
  final Timestamp startTime;
  final Timestamp endTime;

  PlaceMarker(
      {@required this.title,
      @required this.subtitle,
      @required this.startTime,
      @required this.endTime,
      @required point,
      @required builder})
      : super(
          point: point,
          builder: builder,
        );

  static PlaceMarker fromFireStoreSnapshot(DocumentSnapshot snapshot) {
    return PlaceMarker(
      title: snapshot.data()['title'],
      subtitle: snapshot.data()['subtitle'],
      startTime: snapshot.data()['start_time'],
      endTime: snapshot.data()['end_time'],
      point: LatLng(
          snapshot.data()['geo'].latitude, snapshot.data()['geo'].longitude),
      builder: (BuildContext context) => FaIcon(
        FontAwesomeIcons.virus,
        color: AppColors.kColorPrimary,
      ),
    );
  }

  @override
  List<Object> get props => [title, point.longitude, point.longitude];
}
