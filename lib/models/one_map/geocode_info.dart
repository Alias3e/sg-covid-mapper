import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geocode_info.g.dart';

@JsonSerializable()
class GeocodeInfo extends Equatable {
  @JsonKey(name: 'BUILDINGNAME')
  final String buildingName;
  @JsonKey(name: 'BLOCK')
  final String block;
  @JsonKey(name: 'ROAD')
  final String road;
  @JsonKey(name: 'LATITUDE')
  final String latitudeString;
  @JsonKey(name: 'LONGITUDE')
  final String longitudeString;
  @JsonKey(name: 'POSTALCODE')
  final String postalCode;

  GeocodeInfo({
    this.buildingName,
    this.block,
    this.road,
    this.latitudeString,
    this.longitudeString,
    this.postalCode,
  });

  factory GeocodeInfo.fromJson(Map<String, dynamic> json) =>
      _$GeocodeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodeInfoToJson(this);

  double get latitude => double.parse(latitudeString);

  double get longitude => double.parse(longitudeString);

  @override
  List<Object> get props =>
      [buildingName, postalCode, block, road, latitudeString, longitudeString];
}
