// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_search.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneMapSearch _$OneMapSearchFromJson(Map<String, dynamic> json) {
  return OneMapSearch(
    OneMapSearch._fromSearchResults(json['results'] as List),
  );
}

Map<String, dynamic> _$OneMapSearchToJson(OneMapSearch instance) =>
    <String, dynamic>{
      'results': OneMapSearch._toSearchResultList(instance.results),
    };
