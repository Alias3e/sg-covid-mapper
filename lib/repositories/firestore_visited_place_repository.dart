import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class FirestoreVisitedPlaceRepository extends VisitedPlaceRepository {
  final collection = Firestore.instance.collection('places');

  @override
  Stream<List<PlaceMarker>> get placeMarkers {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((place) => PlaceMarker.fromFireStoreSnapshot(place))
          .toList();
    });
  }
}
