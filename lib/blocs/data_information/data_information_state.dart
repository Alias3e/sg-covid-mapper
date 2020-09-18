import 'package:equatable/equatable.dart';

abstract class DataInformationState extends Equatable {}

class AwaitingData extends DataInformationState {
  @override
  List<Object> get props => [];
}

class DataInformationUpdated extends DataInformationState {
  final Map<String, dynamic> map;

  DataInformationUpdated(this.map);

  @override
  List<Object> get props => [map];
}
