import 'package:equatable/equatable.dart';
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

class OnDeleteCancelled extends LogEvent {
  @override
  List<Object> get props => [];
}

class EditLogEntry extends LogEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class OnEditButtonPressed extends LogEvent {
  final Visit visit;

  OnEditButtonPressed(this.visit);

  @override
  List<Object> get props => throw UnimplementedError();
}
