import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/covid_location.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';
import 'package:sgcovidmapper/models/timeline/location_timeline_item.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/util/constants.dart';

class FirestoreCovidPlacesRepository extends CovidPlacesRepository {
  final CollectionReference locationCollection;
  final CollectionReference systemCollection;
  Timestamp updated;

  @override
  String get dataUpdated => Styles.kUpdatedDateFormat.format(updated.toDate());

  FirestoreCovidPlacesRepository(
      {this.locationCollection, this.systemCollection})
      : assert(locationCollection != null && systemCollection != null);

  Future<void> init() async {
    if (updated == null) {
      DocumentReference docRef =
          systemCollection.document('Wn7Rh8YtfIyKliO02Ltl');
      DocumentSnapshot snapshot = await docRef.get();
      version = snapshot.data['current_version'];
      updated = snapshot.data['updated'];
      source = snapshot.data['source'];
    }
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
  Stream<List<ChildTimelineItem>> get timelineTiles => locationCollection
          .document(version)
          .collection('locations')
          .snapshots()
          .map((snapshot) {
        return snapshot.documents
            .map((place) => LocationTimelineItem.fromFirestoreSnapshot(place))
            .toList();
      });

  @override
  Stream<List<CovidLocation>> get covidLocations => locationCollection
      .document(version)
      .collection('locations')
      .snapshots()
      .map((snapshot) => snapshot.documents
          .map((place) => CovidLocation.fromFirestoreSnapshot(place))
          .toList());
}
