import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgcovidmapper/models/one_map_search_result.dart';

part 'one_map_search.g.dart';

@JsonSerializable(explicitToJson: true)
class OneMapSearch extends Equatable {
  final List<OneMapSearchResult> results;

  factory OneMapSearch.fromJson(Map<String, dynamic> json) =>
      _$OneMapSearchFromJson(json);

  Map<String, dynamic> toJson() => _$OneMapSearchToJson(this);

  int get count => results == null ? 0 : results.length;

  OneMapSearch(this.results);
  @override
  List<Object> get props {
    List<Object> props = [];
    for (OneMapSearchResult result in results) props.add(result);
    return props;
  }
}
