import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_event.dart';
import 'package:sgcovidmapper/blocs/timeline/timeline_state.dart';
import 'package:sgcovidmapper/models/timeline/timeline.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';

class TimelineBloc extends Bloc<TimelineEvent, TimelineState> {
  final CovidPlacesRepository repository;

  StreamSubscription<List<IndicatorTimelineItem>> _subscription;

  TimelineBloc({@required this.repository}) : assert(repository != null) {
    getSubscription();
  }

  Future<void> getSubscription() async {
    await repository.init();
    _subscription =
        repository.timelineTiles.listen((event) => add(HasTimelineData(event)));
  }

  @override
  TimelineState get initialState => TimelineEmpty();

  @override
  Stream<TimelineState> mapEventToState(TimelineEvent event) async* {
    if (event is HasTimelineData) {
      repository.timelineItemCached = event.timelineItems;
      yield TimelineLoaded(TimelineModel.fromLocation(event.timelineItems, []));
    }
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
