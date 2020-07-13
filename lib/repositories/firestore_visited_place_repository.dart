import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class FirestoreVisitedPlaceRepository extends VisitedPlaceRepository {
  final CollectionReference locationCollection;
  final CollectionReference systemCollection;
  String version;
  Timestamp updated;

  FirestoreVisitedPlaceRepository(
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
}
