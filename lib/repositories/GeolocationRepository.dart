import 'package:sgcovidmapper/models/one_map/one_map_search.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/services/firestore_service.dart';
import 'package:sgcovidmapper/services/map_service.dart';
import 'package:sgcovidmapper/services/remote_database_service.dart';
import 'package:sgcovidmapper/util/config.dart';

class GeolocationRepository {
  final GeocodeService _geolocationService;
  final RemoteDatabaseService _remoteDatabaseService;
  String accessToken;

  GeolocationRepository(this._geolocationService, this._remoteDatabaseService)
      : assert(_geolocationService != null && _remoteDatabaseService != null) {
    if (_remoteDatabaseService is FirestoreService) {
      _remoteDatabaseService.oneMap.listen((event) {
        accessToken = event.data['token'];
        int expiry = event.data['expiry'];
        if (accessToken.isEmpty || expiry == 0) _getToken();
        DateTime expiryDateTime =
            DateTime.fromMillisecondsSinceEpoch(expiry * 1000);
        if (DateTime.now().isAfter(expiryDateTime.subtract(Duration(hours: 1))))
          _getToken();
      });
    }
//    _getToken();
  }

  Future<void> _getToken() async {
    OneMapToken newToken;
    newToken = await _geolocationService.authenticate(
        email: Asset.configurations['one_map_api_email'],
        password: Asset.configurations['one_map_api_password']);
    _remoteDatabaseService.updateOneMapToken(newToken);
    accessToken = newToken.accessToken;
    print(
        'new token ${DateTime.fromMillisecondsSinceEpoch(int.parse(newToken.expiryTimestamp) * 1000)}');
  }

  Future<OneMapSearch> search(String search) async {
    OneMapSearch searchResult = await _geolocationService.search({
      'searchVal': search,
      'returnGeom': 'Y',
      'getAddrDetails': 'Y',
    });
    return searchResult;
  }

  Future<ReverseGeocode> reverseGeocode(
      double latitude, double longitude) async {
    ReverseGeocode reverseGeocode = await _geolocationService.reverseGeocode(
        token: accessToken, location: '$latitude,$longitude', buffer: '50');
    return reverseGeocode;
  }
}
