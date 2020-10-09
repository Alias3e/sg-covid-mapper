// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reverse_geocode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReverseGeocode _$ReverseGeocodeFromJson(Map<String, dynamic> json) {
  return ReverseGeocode(
    ReverseGeocode._fromGeocodeInfoList(json['GeocodeInfo'] as List),
  );
}

Map<String, dynamic> _$ReverseGeocodeToJson(ReverseGeocode instance) =>
    <String, dynamic>{
      'GeocodeInfo': ReverseGeocode._toGeocodeInfoList(instance.results),
    };
