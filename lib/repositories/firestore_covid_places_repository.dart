import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';

class FirestoreCovidPlacesRepository extends CovidPlacesRepository {
  final RemoteDatabaseService remoteDatabaseService;

  FirestoreCovidPlacesRepository({
    @required this.remoteDatabaseService,
  }) : assert(remoteDatabaseService != null);

  @override
  Stream<List<PlaceMarker>> get placeMarkers {
    Stream<QuerySnapshot> querySnapshot = remoteDatabaseService.covidLocations;
    return querySnapshot.map((snapshot) {
      return snapshot.documents
          .map((place) => PlaceMarker.fromFireStoreSnapshot(place))
          .toList();
    });
  }

  @override
  Stream<List<ChildTimelineItem>> get timelineTiles {
    Stream<QuerySnapshot> querySnapshot = remoteDatabaseService.covidLocations;
    return querySnapshot.map((snapshot) {
      return snapshot.documents
          .map((place) => LocationTimelineItem.fromFirestoreSnapshot(place))
          .toList();
    });
  }

  @override
  Stream<List<CovidLocation>> get covidLocations {
    Stream<QuerySnapshot> querySnapshot = remoteDatabaseService.covidLocations;
    return querySnapshot.map((snapshot) => snapshot.documents
        .map((place) => CovidLocation.fromFirestoreSnapshot(place))
        .toList());
  }

  @override
  String get source => remoteDatabaseService.source;
}
