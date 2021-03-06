import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class CovidLocation extends Equatable {
  final String postalCode;
  final String title;
  final String subtitle;
  final DateTime startTime;
  final DateTime endTime;

  CovidLocation(
      {@required this.startTime,
      @required this.endTime,
      @required this.postalCode,
      @required this.title,
      this.subtitle});

  @override
  List<Object> get props => [postalCode, title, subtitle];

  factory CovidLocation.fromFirestoreSnapshot(DocumentSnapshot snapshot) {
    Timestamp start = snapshot.data()['start_time'];
    Timestamp end = snapshot.data()['end_time'];
    return CovidLocation(
        postalCode: snapshot.data()['postal_code'],
        title: snapshot.data()['title'],
        subtitle: snapshot.data()['subtitle'],
        startTime: start.toDate(),
        endTime: end.toDate());
  }
}
