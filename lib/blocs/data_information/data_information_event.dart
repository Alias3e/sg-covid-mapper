import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class DataInformationEvent extends Equatable {}

class OnDataInformationUpdated extends DataInformationEvent {
  final Map<String, dynamic> data;

  OnDataInformationUpdated({@required this.data});

  @override
  List<Object> get props => [];
}
