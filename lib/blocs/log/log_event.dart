import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class LogEvent extends Equatable {}

class LogEmpty extends LogEvent {
  @override
  List<Object> get props => [];
}

class LogLoaded extends LogEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class OnDeleteButtonPressed extends LogEvent {
  final Visit visit;

  OnDeleteButtonPressed(this.visit);

  @override
  List<Object> get props => [visit];
}

class OnDeleteConfirmed extends LogEvent {
  final Visit visit;

  OnDeleteConfirmed(this.visit);

  @override
  List<Object> get props => [visit];
}

class OnCancelButtonPressed extends LogEvent {
  @override
  List<Object> get props => [];
}

class OnCheckOutButtonPressed extends LogEvent {
  final Visit visit;

  OnCheckOutButtonPressed({@required this.visit});
  @override
  List<Object> get props => [];
}

class OnEditPanelCheckOutButtonPressed extends LogEvent {
  @override
  List<Object> get props => [];
}

class OnVisitUpdated extends LogEvent {
  final Visit visit;

  OnVisitUpdated(this.visit);
  @override
  List<Object> get props => [visit];
}

class EditLogEntry extends LogEvent {
  final Visit visit;

  EditLogEntry(this.visit);
  @override
  List<Object> get props => [visit];
}

class OnEditButtonPressed extends LogEvent {
  final Visit visit;

  OnEditButtonPressed(this.visit);

  @override
  List<Object> get props => throw UnimplementedError();
}

class OnCheckOutDateTimeSpinnerChanged extends LogEvent {
  final DateTime dateTime;

  OnCheckOutDateTimeSpinnerChanged(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class OnCheckInDateTimeSpinnerChanged extends LogEvent {
  final DateTime dateTime;

  OnCheckInDateTimeSpinnerChanged(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class OnTagDeleteButtonPressed extends LogEvent {
  final Tag tag;

  OnTagDeleteButtonPressed(this.tag);
  @override
  List<Object> get props => [tag];
}

class OnTagAdded extends LogEvent {
  final Tag tag;

  OnTagAdded(this.tag);

  @override
  List<Object> get props => [tag];
}

class OnEditCancelled extends LogEvent {
  OnEditCancelled();
  @override
  List<Object> get props => [];
}
