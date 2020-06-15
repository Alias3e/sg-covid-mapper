import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class FirestoreVisitedPlaceRepository extends VisitedPlaceRepository {
  final CollectionReference collection;

  FirestoreVisitedPlaceRepository(this.collection) : assert(collection != null);

  @override
  Stream<List<PlaceMarker>> get placeMarkers {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((place) => PlaceMarker.fromFireStoreSnapshot(place))
          .toList();
    });
  }
}
