// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneMapSearchResult _$OneMapSearchResultFromJson(Map<String, dynamic> json) {
  return OneMapSearchResult(
    searchValue: json['SEARCHVAL'] as String,
    postalCode: json['POSTAL'] as String,
    latitudeString: json['LATITUDE'] as String,
    longitudeString: json['LONGITUDE'] as String,
    address: json['ADDRESS'] as String,
  );
}

Map<String, dynamic> _$OneMapSearchResultToJson(OneMapSearchResult instance) =>
    <String, dynamic>{
      'SEARCHVAL': instance.searchValue,
      'POSTAL': instance.postalCode,
      'LATITUDE': instance.latitudeString,
      'LONGITUDE': instance.longitudeString,
      'ADDRESS': instance.address,
    };
