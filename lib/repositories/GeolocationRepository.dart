import 'package:sgcovidmapper/models/one_map/one_map_search.dart';
import 'package:sgcovidmapper/services/map_service.dart';

class GeolocationRepository {
  final GeocodeService _geolocationService;

  GeolocationRepository(this._geolocationService);

  Future<OneMapSearch> search(String search) async {
    OneMapSearch searchResult = await _geolocationService.search({
      'searchVal': search,
      'returnGeom': 'Y',
      'getAddrDetails': 'Y',
    });
    return searchResult;
  }
}
