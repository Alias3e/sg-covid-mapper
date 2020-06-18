import 'package:sgcovidmapper/models/one_map_search.dart';
import 'package:sgcovidmapper/services/map_service.dart';

class OneMapRepository {
  final MapService _mapService;

  OneMapRepository(this._mapService);

  Future<OneMapSearch> getMapSearch(String search) async {
    OneMapSearch searchResult = await _mapService.search({
      'searchVal': search,
      'returnGeom': 'Y',
      'getAddrDetails': 'N',
    });
    return searchResult;
  }
}
