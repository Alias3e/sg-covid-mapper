import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';

class FirestoreService extends RemoteDatabaseService {
  CollectionReference _locationCollection;
  CollectionReference _systemCollection;
  DocumentSnapshot systemSnapshot;

  @override
  Stream<DocumentSnapshot> get systems =>
      _systemCollection.document('Wn7Rh8YtfIyKliO02Ltl').snapshots();

  @override
  Stream<QuerySnapshot> get covidLocations => _locationCollection
      .document(covidDbVersion)
      .collection('locations')
      .snapshots();

  @override
  void init() {
    _locationCollection = Firestore.instance.collection('all_locations');
    _systemCollection = Firestore.instance.collection('system');
    systems.listen((snapshot) {
      covidDbVersion = snapshot['current_version'];
      updated = (snapshot.data['updated'] as Timestamp).toDate();
      source = snapshot.data['source'];
      print('$covidDbVersion $updated $source');
    });
  }

  @override
  DateTime get oneMapKeyExpiryDate =>
      DateTime.fromMillisecondsSinceEpoch(oneMapKeyExpiryTimestamp * 1000);
}
