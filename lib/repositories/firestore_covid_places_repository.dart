import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';

class FirestoreCovidPlacesRepository extends CovidPlacesRepository {
  final CollectionReference locationCollection;
  final CollectionReference systemCollection;
  String version;
  Timestamp updated;

  FirestoreCovidPlacesRepository(
      {this.locationCollection, this.systemCollection})
      : assert(locationCollection != null && systemCollection != null);

  Future<void> init() async {
    DocumentReference docRef =
        systemCollection.document('Wn7Rh8YtfIyKliO02Ltl');
    DocumentSnapshot snapshot = await docRef.get();
    version = snapshot.data['current_version'];
    updated = snapshot.data['updated'];
  }

  @override
  Stream<List<PlaceMarker>> get placeMarkers {
    return locationCollection
        .document(version)
        .collection('locations')
        .snapshots()
        .map((snapshot) {
      return snapshot.documents
          .map((place) => PlaceMarker.fromFireStoreSnapshot(place))
          .toList();
    });
  }

  @override
  Stream<List<IndicatorTimelineItem>> get timelineTiles => locationCollection
          .document(version)
          .collection('locations')
          .snapshots()
          .map((snapshot) {
        return snapshot.documents
            .map((place) => LocationTimelineItem.fromFirestoreSnapshot(place))
            .toList();
      });
}
