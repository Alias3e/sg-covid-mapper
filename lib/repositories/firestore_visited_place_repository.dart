import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/visited_place.dart';
import 'package:sgcovidmapper/repositories/visited_place_repository.dart';

class FirestoreVisitedPlaceRepository extends VisitedPlaceRepository {
  final collection = Firestore.instance.collection('places');

  @override
  Stream<List<VisitedPlace>> get visitedPlaces {
    return collection.snapshots().map((snapshot) {
      return snapshot.documents
          .map((place) => VisitedPlace.fromFireStoreSnapshot(place))
          .toList();
    });
  }
}
