import 'package:equatable/equatable.dart';
import 'package:sgcovidmapper/models/timeline/timeline_model.dart';

abstract class TimelineState extends Equatable {}

class TimelineEmpty extends TimelineState {
  @override
  List<Object> get props => [];
}

class TimelineLoaded extends TimelineState {
  final TimelineModel model;

  TimelineLoaded(this.model);

  @override
  List<Object> get props => [model];
}
