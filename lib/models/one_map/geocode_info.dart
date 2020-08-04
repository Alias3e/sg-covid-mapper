import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'geocode_info.g.dart';

@JsonSerializable()
class GeoCodeInfo extends Equatable {
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

  GeoCodeInfo({
    this.buildingName,
    this.block,
    this.road,
    this.latitudeString,
    this.longitudeString,
    this.postalCode,
  });

  factory GeoCodeInfo.fromJson(Map<String, dynamic> json) =>
      _$GeoCodeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$GeoCodeInfoToJson(this);

  double get latitude => double.parse(latitudeString);

  double get longitude => double.parse(longitudeString);

  @override
  // TODO: implement props
  List<Object> get props =>
      [buildingName, postalCode, block, road, latitudeString, longitudeString];
}
