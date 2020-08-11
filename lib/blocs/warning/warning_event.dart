import 'package:equatable/equatable.dart';

abstract class WarningEvent extends Equatable {}

class WarningChanged extends WarningEvent {
  final int timestamp;

  WarningChanged(this.timestamp);

  @override
  List<Object> get props => [timestamp];
}
