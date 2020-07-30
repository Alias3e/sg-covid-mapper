import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';

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
  List<Tag> tags;

  @HiveField(5)
  String postalCode;

  @HiveField(6)
  int warningLevel;

  Visit() {
    tags = [];
  }

  static String getHiveKey(Visit visit) {
    String tagsString = '';
    if (visit.tags.isNotEmpty)
      for (Tag tag in visit.tags) tagsString = tagsString + tag.label;

    var bytes = utf8.encode(
        '${visit.title}${visit.checkInTime.toString()}${visit.checkOutTime.toString()}$tagsString');
    return sha1.convert(bytes).toString();
  }

  LatLng get geo {
    return LatLng(this.latitude, this.longitude);
  }

  void addTags(List<String> tagStrings) {
    tagStrings.forEach((tagString) {
      tags.add(Tag(tagString));
    });
  }

  void setWarningLevel(CovidLocation item) {
    this.warningLevel = 0;
    if (item.postalCode == postalCode) {
      if (isOverlap(item.startTime, item.endTime)) {
        warningLevel++;
        for (Tag tag in tags) {
          if (item.subtitle.contains(tag.label) ||
              item.title.contains(tag.label)) warningLevel++;
          tag.isVisitedByInfected = true;
        }
      }
    }
    if (this.isInBox) this.save();
  }

  bool isOverlap(DateTime startTime, DateTime endTime) =>
      this.checkInTime.compareTo(endTime) <= 0 &&
      checkOutTime.compareTo(startTime) >= 0;
}
