import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';

abstract class CheckPanelEvent extends Equatable {}

class DisplayLocationCheckInPanel extends CheckPanelEvent {
  final CheckInPanelData data;
  DisplayLocationCheckInPanel(this.data);

  @override
  // TODO: implement props
  List<Object> get props => [data];
}

class CheckInDateTimeUpdated extends CheckPanelEvent {
  final DateTime dateTime;

  CheckInDateTimeUpdated(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class CheckOutDateTimeUpdated extends CheckPanelEvent {
  final DateTime dateTime;

  CheckOutDateTimeUpdated(this.dateTime);

  @override
  // TODO: implement props
  List<Object> get props => [dateTime];
}

class CheckOutDateTimeDisplayed extends CheckPanelEvent {
  @override
  List<Object> get props => [];
}
