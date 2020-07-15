import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';

part 'visit.g.dart';

@HiveType(typeId: 0)
class Visit extends HiveObject {
  // Title/name of the visited place.
  @HiveField(0)
  String title;
  // Latitude of the location
  @HiveField(1)
  double latitude;
  // Longitude of the location
  @HiveField(2)
  double longitude;
  // The start date time when the place was visited by the user.
  @HiveField(3)
  DateTime checkInTime;
  // the end date time when the place was visited by the user.
  DateTime checkOutTime;
  @HiveField(4)
  List<String> tags;

  @HiveField(5)
  String postalCode;

  Visit() {
    tags = [];
  }

  static String getHiveKey(Visit visit) {
    String tagsString = '';
    if (visit.tags.isNotEmpty)
      for (String tag in visit.tags) tagsString = tagsString + tag;

    var bytes = utf8.encode(
        '${visit.title}${visit.checkInTime.toString()}${visit.checkOutTime.toString()}$tagsString');
    return sha1.convert(bytes).toString();
  }

  LatLng get geo {
    return LatLng(this.latitude, this.longitude);
  }
}
