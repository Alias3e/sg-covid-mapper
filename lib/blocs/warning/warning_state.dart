import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class WarningState extends Equatable {}

class WarningLevelUnchanged extends WarningState {
  @override
  List<Object> get props => [];
}

class WarningLevelUpdated extends WarningState {
  final int timestamp;

  WarningLevelUpdated(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class DisplayAlerts extends WarningState {
  final List<Visit> alerts;

  DisplayAlerts(this.alerts);

  @override
  List<Object> get props => [alerts];
}
