import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgcovidmapper/models/one_map/geocode_info.dart';

part 'reverse_geocode.g.dart';

@JsonSerializable(explicitToJson: true)
class ReverseGeocode extends Equatable {
  @JsonKey(name: 'GeocodeInfo')
  final List<GeoCodeInfo> results;

  ReverseGeocode(this.results);

  factory ReverseGeocode.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseGeocodeToJson(this);

  @override
  // TODO: implement props
  List<Object> get props => [results];
}
