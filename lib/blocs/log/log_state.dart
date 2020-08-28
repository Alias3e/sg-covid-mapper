import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/hive/tag.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class LogState extends Equatable {}

abstract class LogPanelState extends LogState {
  final double maxHeight;

  LogPanelState({@required this.maxHeight});
}

abstract class LogPanelShowingState extends LogPanelState {
  LogPanelShowingState({@required maxHeight}) : super(maxHeight: maxHeight);
}

class LogStateInitial extends LogState {
  @override
  List<Object> get props => [];
}

class DeleteConfirmationPanelShowing extends LogPanelShowingState {
  final Visit visit;

  DeleteConfirmationPanelShowing(this.visit) : super(maxHeight: 0.25);

  @override
  List<Object> get props => [visit];
}

class CheckOutPanelShowing extends LogPanelShowingState {
  final Visit visit;

  CheckOutPanelShowing(this.visit) : super(maxHeight: 0.33);

  @override
  List<Object> get props => [visit];
}

class EditVisitPanelShowing extends LogPanelShowingState {
  final Visit visit;

  EditVisitPanelShowing(this.visit) : super(maxHeight: 1.0);

  @override
  List<Object> get props => [visit];
}

class LogPanelClosing extends LogPanelState {
  LogPanelClosing({@required maxHeight}) : super(maxHeight: maxHeight);

  @override
  List<Object> get props => [];
}

class VisitDeleteInProgress extends LogState {
  final Visit visit;

  VisitDeleteInProgress(this.visit);

  @override
  List<Object> get props => [];
}

class VisitDeleteCompleted extends LogPanelClosing {
  final Visit visit;

  VisitDeleteCompleted({@required this.visit, @required maxHeight})
      : super(maxHeight: maxHeight);

  @override
  List<Object> get props => [];
}

class VisitUpdateInProgress extends LogState {
  @override
  List<Object> get props => [];
}

class VisitUpdateCompleted extends LogPanelClosing {
  VisitUpdateCompleted({@required maxHeight}) : super(maxHeight: maxHeight);
}

class CheckOutPickerDisplayed extends LogState {
  final DateTime dateTime;

  CheckOutPickerDisplayed(this.dateTime);
  @override
  List<Object> get props => [];
}

class EditCheckInDateTimeUpdated extends LogState {
  final DateTime dateTime;

  EditCheckInDateTimeUpdated(this.dateTime);
  @override
  List<Object> get props => [dateTime];
}

class EditCheckOutDateTimeUpdated extends LogState {
  final DateTime dateTime;

  EditCheckOutDateTimeUpdated(this.dateTime);

  @override
  List<Object> get props => [dateTime];
}

class TagsUpdated extends LogState {
  final Tag tag;

  TagsUpdated(this.tag);

  @override
  List<Object> get props => [tag];
}
