import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/one_map_search_result.dart';

part 'one_map_search.g.dart';

@JsonSerializable(explicitToJson: true)
class OneMapSearch extends Equatable {
  @JsonKey(fromJson: _fromSearchResults, toJson: _toSearchResultList)
  final List<CommonOneMapModel> results;

  factory OneMapSearch.fromJson(Map<String, dynamic> json) =>
      _$OneMapSearchFromJson(json);

  Map<String, dynamic> toJson() => _$OneMapSearchToJson(this);

  int get count => results == null ? 0 : results.length;

  OneMapSearch(this.results);
  @override
  List<Object> get props {
    List<Object> props = [];
    for (CommonOneMapModel result in results) props.add(result);
    return props;
  }

  static List<CommonOneMapModel> _fromSearchResults(List<dynamic> data) {
    List<CommonOneMapModel> models = [];
    data.forEach((result) {
      CommonOneMapModel model = CommonOneMapModel.fromSearchResultModel(
          OneMapSearchResult.fromJson(result));
      if (model.postalCode != 'NIL') models.add(model);
    });
    return models;
  }

  static List<dynamic> _toSearchResultList(List<CommonOneMapModel> models) {
    return [];
  }
}
