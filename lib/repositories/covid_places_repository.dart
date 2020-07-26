import 'package:sgcovidmapper/models/place_marker.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';

abstract class CovidPlacesRepository {
  List<PlaceMarker> placeMarkersCached = [];
  List<IndicatorTimelineItem> timelineItemCached = [];
  Future<void> init();
  Stream<List<PlaceMarker>> get placeMarkers;
  Stream<List<IndicatorTimelineItem>> get timelineTiles;
}
