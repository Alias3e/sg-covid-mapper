// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneMapSearch _$OneMapSearchFromJson(Map<String, dynamic> json) {
  return OneMapSearch(
    (json['results'] as List)
        ?.map((e) => e == null
            ? null
            : OneMapSearchResult.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$OneMapSearchToJson(OneMapSearch instance) =>
    <String, dynamic>{
      'results': instance.results?.map((e) => e?.toJson())?.toList(),
    };
