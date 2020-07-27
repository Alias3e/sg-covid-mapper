import 'package:sgcovidmapper/models/hive/visit.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/services/local_storage_service.dart';

class MyVisitedPlaceRepository {
  final LocalStorageService _service;

  MyVisitedPlaceRepository(this._service);

  Future<void> saveVisit(Visit visit) async {
    await _service.save(visit);
  }

  List<ChildTimelineItem> loadVisits() {
//    return _service.visits
//        .map((visit) => VisitTimelineItem.fromHiveVisit(visit))
//        .toList();
    return List<ChildTimelineItem>()
      ..addAll(_service.visits
          .map((visit) => VisitTimelineItem.fromHiveVisit(visit))
          .toList());
  }

  void listen(Function listener) {
    _service.visitListenable().addListener(listener);
  }
}
