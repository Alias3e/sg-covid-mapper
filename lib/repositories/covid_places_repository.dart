import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/models/timeline/indicator_timeline_item.dart';

abstract class CovidPlacesRepository {
  List<PlaceMarker> placeMarkersCached = [];
  List<ChildTimelineItem> timelineItemCached = [];
  List<CovidLocation> covidLocationsCached = [];
  Stream<List<PlaceMarker>> get placeMarkers;
  Stream<List<ChildTimelineItem>> get timelineTiles;
  Stream<List<CovidLocation>> get covidLocations;
}
