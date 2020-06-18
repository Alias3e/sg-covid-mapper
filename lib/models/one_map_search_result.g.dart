// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_search_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneMapSearchResult _$OneMapSearchResultFromJson(Map<String, dynamic> json) {
  return OneMapSearchResult(
    json['SEARCHVAL'] as String,
    json['POSTAL'] as String,
    json['LATITUDE'] as String,
    json['LONGITUDE'] as String,
  );
}

Map<String, dynamic> _$OneMapSearchResultToJson(OneMapSearchResult instance) =>
    <String, dynamic>{
      'SEARCHVAL': instance.searchValue,
      'POSTAL': instance.postalCode,
      'LATITUDE': instance.latitude,
      'LONGITUDE': instance.longitude,
    };
