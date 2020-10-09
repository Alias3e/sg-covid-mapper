import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class TimelineItem extends Equatable {
  final double lineX;

  TimelineItem({@required this.lineX});
}
