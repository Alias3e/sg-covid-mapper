import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class CheckPanelState extends Equatable {}

class CheckPanelLoaded extends CheckPanelState {
  final CheckInPanelData data;

  CheckPanelLoaded(this.data);

  @override
  List<Object> get props => [data];
}

class CheckPanelInitialized extends CheckPanelState {
  CheckPanelInitialized();

  @override
  List<Object> get props => [];
}

class CheckInDateTimeTextRefreshed extends CheckPanelState {
  final DateTime dateTime;

  CheckInDateTimeTextRefreshed({@required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CheckOutDateTimeTextRefreshed extends CheckPanelState {
  final DateTime dateTime;
  CheckOutDateTimeTextRefreshed({@required this.dateTime});

  @override
  List<Object> get props => [dateTime];
}

class CheckOutDateTimeWidgetLoaded extends CheckPanelState {
  @override
  List<Object> get props => [];
}

class CheckOutDateTimeWidgetHidden extends CheckPanelState {
  @override
  List<Object> get props => [];
}

class TagListUpdated extends CheckPanelState {
  final List<Chip> tags;

  TagListUpdated({@required this.tags});

  @override
  List<Object> get props => [tags.length];
}

class VisitSaved extends CheckPanelState {
  final Visit visit;
  final dynamic hiveKey;

  VisitSaved(this.visit, this.hiveKey);

  @override
  List<Object> get props => [visit];
}
