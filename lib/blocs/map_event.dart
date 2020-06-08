//region Map Events
import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/visited_place.dart';

abstract class MapEvent extends Equatable {
  const MapEvent();
}

// Event when Firestore stream has new places data.
class HasPlacesData extends MapEvent {
  final List<VisitedPlace> visitedPlaces;

  HasPlacesData(this.visitedPlaces);

  @override
  List<Object> get props => [visitedPlaces];
}

class GetGPS extends MapEvent {
  @override
  List<Object> get props => [];
}
//endregion
