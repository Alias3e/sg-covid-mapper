import 'package:sgcovidmapper/models/one_map/one_map_search.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/services/local_storage_service.dart';
import 'package:sgcovidmapper/services/map_service.dart';
import 'package:sgcovidmapper/util/config.dart';

class GeolocationRepository {
  final GeocodeService _geolocationService;
  final LocalStorageService _localStorageService;
  String accessToken;

  GeolocationRepository(this._geolocationService, this._localStorageService) {
    _getToken();
  }

  Future<void> _getToken() async {
    accessToken = _localStorageService.oneMapToken;
    if (accessToken.isEmpty) {
      OneMapToken newToken;
      newToken = await _geolocationService.authenticate(
          email: Asset.configurations['one_map_api_email'],
          password: Asset.configurations['one_map_api_password']);
      _localStorageService.saveOneMapToken(newToken);
      accessToken = newToken.accessToken;
    }
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
