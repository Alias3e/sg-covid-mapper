import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class LogState extends Equatable {}

abstract class LogPanelState extends LogState {
  final double maxHeight;

  LogPanelState({@required this.maxHeight});
}

class LogStateInitial extends LogState {
  @override
  List<Object> get props => [];
}

class DeleteConfirmationPanelShowing extends LogPanelState {
  final Visit visit;

  DeleteConfirmationPanelShowing(this.visit) : super(maxHeight: 0.25);

  @override
  List<Object> get props => [visit];
}

class PanelClosing extends LogPanelState {
  PanelClosing({@required maxHeight}) : super(maxHeight: maxHeight);

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
