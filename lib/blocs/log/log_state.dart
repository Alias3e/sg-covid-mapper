import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
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

class VisitDeleteCompleted extends LogPanelState {
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
  VisitUpdateCompleted({@required maxHeight}):super(maxHeight: maxHeight);
}

