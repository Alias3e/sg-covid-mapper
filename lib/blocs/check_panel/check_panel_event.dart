import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';

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

class AddTag extends CheckPanelEvent {
  final String tagName;

  AddTag({@required this.tagName});

  @override
  List<Object> get props => [tagName];
}

class RemoveTag extends CheckPanelEvent {
  final String tagName;

  RemoveTag({@required this.tagName});

  @override
  List<Object> get props => [tagName];
}

class SaveVisit extends CheckPanelEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class CancelVisit extends CheckPanelEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
