// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseGeocode _$ReverseGeocodeFromJson(Map<String, dynamic> json) {
  return ReverseGeocode(
    (json['GeocodeInfo'] as List)
        ?.map((e) =>
            e == null ? null : GeoCodeInfo.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$ReverseGeocodeToJson(ReverseGeocode instance) =>
    <String, dynamic>{
      'GeocodeInfo': instance.results?.map((e) => e?.toJson())?.toList(),
    };
