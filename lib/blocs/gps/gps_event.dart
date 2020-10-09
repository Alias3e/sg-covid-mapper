import 'package:equatable/equatable.dart';

abstract class GpsEvent extends Equatable {}

class GetGps extends GpsEvent {
  @override
  List<Object> get props => [];
}
