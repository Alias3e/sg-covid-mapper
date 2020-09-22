import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';

class FirestoreService extends RemoteDatabaseService {
  CollectionReference _locationCollection;
  CollectionReference _systemCollection;
  DocumentSnapshot systemSnapshot;

  @override
  Stream<DocumentSnapshot> get systems =>
      _systemCollection.document('moh').snapshots();

  @override
  Stream<QuerySnapshot> get covidLocations => _locationCollection
      .document(covidDbVersion)
      .collection('locations')
      .snapshots();

  @override
  Stream<DocumentSnapshot> get oneMap =>
      _systemCollection.document('one_map').snapshots();

  @override
  void init() {
    _locationCollection = Firestore.instance.collection('all_locations');
    _systemCollection = Firestore.instance.collection('system');
    systems.listen((snapshot) {
      covidDbVersion = snapshot['current_version'];
      updated = (snapshot.data['updated'] as Timestamp).toDate();
      source = snapshot.data['source'];
    });
  }

  @override
  DateTime get oneMapKeyExpiryDate =>
      DateTime.fromMillisecondsSinceEpoch(oneMapKeyExpiryTimestamp * 1000);

  @override
  void updateOneMapToken(OneMapToken token) {
    DocumentReference docRef = _systemCollection.document('one_map');

    docRef.get().then((doc) {
      if (doc.exists) {
        docRef.updateData({
          'token': token.accessToken,
          'expiry': int.parse(token.expiryTimestamp)
        });
      }
    });
  }
}
