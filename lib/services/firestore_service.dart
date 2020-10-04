import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';

class FirestoreService extends RemoteDatabaseService {
  CollectionReference _locationCollection;
  CollectionReference _systemCollection;
  DocumentSnapshot systemSnapshot;

  @override
  Stream<DocumentSnapshot> get systems =>
      _systemCollection.doc('moh').snapshots();

  @override
  Stream<QuerySnapshot> get covidLocations => _locationCollection
      .doc(covidDbVersion)
      .collection('locations')
      .snapshots();

  @override
  Stream<DocumentSnapshot> get oneMap =>
      _systemCollection.doc('one_map').snapshots();

  @override
  Future<void> init() async {
    _locationCollection =
        FirebaseFirestore.instance.collection('all_locations');
    _systemCollection = FirebaseFirestore.instance.collection('system');

    await _systemCollection.doc('moh').get().then((doc) {
      if (doc.exists) {
        covidDbVersion = doc.data()['current_version'];
        updated = (doc.data()['updated'] as Timestamp).toDate();
        source = doc.data()['source'];
        print("doc version : ${doc.data()['current_version']}");
      }
    });
  }

  @override
  DateTime get oneMapKeyExpiryDate =>
      DateTime.fromMillisecondsSinceEpoch(oneMapKeyExpiryTimestamp * 1000);

  @override
  void updateOneMapToken(OneMapToken token) {
    DocumentReference docRef = _systemCollection.doc('one_map');

    docRef.get().then((doc) {
      if (doc.exists) {
        docRef.update({
          'token': token.accessToken,
          'expiry': int.parse(token.expiryTimestamp)
        });
      }
    });
  }
}
