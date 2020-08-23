import 'package:equatable/equatable.dart';

abstract class LogEvent extends Equatable {}

class LogEmpty extends LogEvent {
  @override
  List<Object> get props => [];
}

class LogLoaded extends LogEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class DeleteLogEntry extends LogEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}

class EditLogEntry extends LogEvent {
  @override
  List<Object> get props => throw UnimplementedError();
}
