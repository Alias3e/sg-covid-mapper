import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_event.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_state.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:sgcovidmapper/repositories/my_visited_place_repository.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final CovidPlacesRepository covidRepository;
  final MyVisitedPlaceRepository visitsRepository;

  StreamSubscription<List<ChildTimelineItem>> _subscription;

  TimelineBloc(
      {@required this.visitsRepository, @required this.covidRepository})
      : assert(covidRepository != null && visitsRepository != null) {
    getSubscription();
  }

  Future<void> getSubscription() async {
    await covidRepository.init();
    _subscription = covidRepository.timelineTiles.listen((event) {
      covidRepository.timelineItemCached = event;
      _addTimelineDataEvent();
    });
    visitsRepository.listen(_addTimelineDataEvent);
  }

  void _addTimelineDataEvent() {
    List<ChildTimelineItem> items = [];
    items
      ..addAll(covidRepository.timelineItemCached)
      ..addAll(visitsRepository.loadVisits());
    add(HasTimelineData(items));
  }

  @override
  TimelineState get initialState => TimelineEmpty();

  @override
  Stream<TimelineState> mapEventToState(TimelineEvent event) async* {
    if (event is HasTimelineData) {
      yield TimelineLoaded(TimelineModel.fromLocation(event.timelineItems));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
