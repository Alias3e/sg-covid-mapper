import 'package:equatable/equatable.dart';

abstract class WarningEvent extends Equatable {}

class DataChanged extends WarningEvent {
  @override
  List<Object> get props => [];
}
