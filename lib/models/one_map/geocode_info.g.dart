// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'geocode_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeoCodeInfo _$GeoCodeInfoFromJson(Map<String, dynamic> json) {
  return GeoCodeInfo(
    buildingName: json['BUILDINGNAME'] as String,
    block: json['BLOCK'] as String,
    road: json['ROAD'] as String,
    latitudeString: json['LATITUDE'] as String,
    longitudeString: json['LONGITUDE'] as String,
    postalCode: json['POSTALCODE'] as String,
  );
}

Map<String, dynamic> _$GeoCodeInfoToJson(GeoCodeInfo instance) =>
    <String, dynamic>{
      'BUILDINGNAME': instance.buildingName,
      'BLOCK': instance.block,
      'ROAD': instance.road,
      'LATITUDE': instance.latitudeString,
      'LONGITUDE': instance.longitudeString,
      'POSTALCODE': instance.postalCode,
    };
