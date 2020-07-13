import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_event.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_state.dart';

class CheckPanelBloc extends Bloc<CheckPanelEvent, CheckPanelState> {
  CheckPanelBloc();

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
    if (event is CheckInDateTimeUpdated)
      yield CheckInDateTimeTextRefreshed(dateTime: event.dateTime);

    if (event is CheckOutDateTimeUpdated)
      yield CheckOutDateTimeTextRefreshed(dateTime: event.dateTime);

    if (event is CheckOutDateTimeDisplayed)
      yield CheckOutDateTimeWidgetLoaded();

    if (event is DisplayLocationCheckInPanel)
      yield CheckPanelLoaded(event.data);
  }
}
