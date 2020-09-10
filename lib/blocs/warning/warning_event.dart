import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/hive/visit.dart';

abstract class WarningEvent extends Equatable {}

class WarningChanged extends WarningEvent {
  final int timestamp;

  WarningChanged(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}

class OnAlertFound extends WarningEvent {
  final List<Visit> alerts;

  OnAlertFound(this.alerts);

  @override
  List<Object> get props => [alerts];
}
