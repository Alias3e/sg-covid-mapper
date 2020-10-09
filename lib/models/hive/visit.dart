import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/util/constants.dart';

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
  @HiveField(7)
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

  bool setWarningLevel(List<CovidLocation> items) {
    int newWarningLevel = 0;
    for (CovidLocation item in items) {
      if (item.postalCode == postalCode) {
        if (isOverlap(item.startTime, item.endTime)) {
          newWarningLevel++;
          for (Tag tag in tags) {
            tag.updateSimilarity(item.title, item.subtitle);
//            double titleSimilarity = 0;
//            double subTitleSimilarity = 0;
//
//            titleSimilarity = checkTitle(item.title, tag);
//            subTitleSimilarity = findStringSimilarity(item.subtitle, tag.label);
//            tag.similarity = titleSimilarity > subTitleSimilarity
//                ? titleSimilarity
//                : subTitleSimilarity;
            if (item.subtitle.contains(tag.label) ||
                item.title.contains(tag.label)) newWarningLevel++;
            tag.isVisitedByInfected = true;
          }
        }
      }
    }
    bool needAlert = false;
    if (warningLevel == null) {
      if (newWarningLevel > 0) needAlert = true;
    } else {
      if (newWarningLevel > warningLevel && warningLevel == 0) needAlert = true;
    }

    this.warningLevel = newWarningLevel;
    if (this.isInBox) {
      this.save();
    }
    return needAlert;
  }

//  double checkTitle(String title, Tag tag) {
//    List<String> titleTokens = title.split('(');
//    if (titleTokens.length == 0) return 0.0;
//    if (titleTokens[0].toLowerCase().contains(tag.label.toLowerCase()))
//      return 1.0;
//    else {
//      List<String> tagTokens = tag.label.split(' ');
//      if (tagTokens.length > 1) {
//        bool allMatch = true;
//        for (String labelToken in tagTokens) {
//          if (!titleTokens[0].contains(labelToken)) allMatch = false;
//        }
//        if (allMatch)
//          return 1.0;
//        else
//          return findStringSimilarity(titleTokens[0], tag.label);
//      }
//      return 0.0;
//    }
//  }

  bool isOverlap(DateTime startTime, DateTime endTime) => checkOutTime != null
      ? this.checkInTime.compareTo(endTime) <= 0 &&
          checkOutTime.compareTo(startTime) >= 0
      : this.checkInTime.compareTo(startTime) >= 0 &&
          this.checkInTime.compareTo(endTime) <= 0;

//  double findStringSimilarity(String titleToken, String label) {
//    double dice = StringSimilarity.compareTwoStrings(
//        titleToken.toLowerCase(), label.toLowerCase());
//
//    return dice;
//  }

  List<Widget> getChips({Function onDeleted, Function onChipTap}) {
    List<Widget> chips = [];
    for (Tag tag in tags) {
      Widget chip = Hero(
        tag: 'edit tag ${tag.label}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: EdgeInsets.only(bottom: 3, right: 3),
            child: GestureDetector(
              onTap: onChipTap != null ? () => onChipTap(tag) : null,
              child: Chip(
                elevation: 2,
                shadowColor: Colors.deepPurple,
                onDeleted: onDeleted != null ? () => onDeleted(tag) : null,
                deleteIconColor: Colors.white,
                label: Text(
                  '${tag.label}${tag.similarity != 1.0 && tag.similarity != 0.0 ? tag.similarityPercentage : ''}',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                backgroundColor: Color.lerp(
                    Colors.deepPurple, AppColors.kColorRed, tag.similarity),
              ),
            ),
          ),
        ),
      );
      chips.add(chip);
    }
    return chips;
  }
}
