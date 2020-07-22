import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:latlong/latlong.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_event.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_state.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

class CheckPanelBloc extends Bloc<CheckPanelEvent, CheckPanelState> {
  final String boxName = 'visits';
  Visit visit;
  Set<String> _labels = {};

  CheckPanelBloc() {
    _openBox();
  }

  Future<void> _openBox() async {
    Hive.registerAdapter(VisitAdapter());
    await Hive.openBox<Visit>(boxName);
  }

  @override
  CheckPanelState get initialState => CheckPanelInitialized();

  @override
  Stream<Transition<CheckPanelEvent, CheckPanelState>> transformEvents(
      Stream<CheckPanelEvent> events, transitionFn) {
    return super.transformEvents(
        events.debounceTime(Duration(milliseconds: 200)), transitionFn);
  }

  @override
  Stream<CheckPanelState> mapEventToState(CheckPanelEvent event) async* {
    if (event is CheckInDateTimeUpdated) {
      visit.checkInTime = event.dateTime;
      yield CheckInDateTimeTextRefreshed(dateTime: event.dateTime);
    }

    if (event is CheckOutDateTimeUpdated) {
      visit.checkOutTime = event.dateTime;
      yield CheckOutDateTimeTextRefreshed(dateTime: event.dateTime);
    }

    if (event is CheckOutDateTimeDisplayed)
      yield CheckOutDateTimeWidgetLoaded();

    if (event is DisplayLocationCheckInPanel) {
      visit = Visit();
      visit.title = event.data.location.searchValue;
      visit.latitude = event.data.location.latitude;
      visit.longitude = event.data.location.longitude;
      LatLng(event.data.location.latitude, event.data.location.longitude);
      yield CheckPanelLoaded(event.data);
    }

    if (event is AddTag) {
      _labels.add(event.tagName);
      yield TagListUpdated(tags: _makeTags());
    }

    if (event is RemoveTag) {
      _labels.remove(event.tagName);
      yield TagListUpdated(tags: _makeTags());
    }

    if (event is SaveVisit) {
      visit.tags = _labels.toList();
      Hive.box<Visit>(boxName).put(Visit.getHiveKey(visit), visit).then((_) {
        _labels.clear();
      });
    }

    if (event is CancelVisit) {
      _labels.clear();
    }
  }

  List<Chip> _makeTags() {
    List<Chip> chips = [];
    for (String chipLabel in _labels) {
      Chip chip = Chip(
        label: Text(
          chipLabel,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.amber,
        deleteIconColor: Colors.white,
        onDeleted: () => this.add(RemoveTag(tagName: chipLabel)),
      );
      chips.add(chip);
    }
    return chips;
  }
}
