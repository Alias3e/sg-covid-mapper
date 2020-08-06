import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/geocode_info.dart';

part 'reverse_geocode.g.dart';

@JsonSerializable(explicitToJson: true)
class ReverseGeocode extends Equatable {
  @JsonKey(
      name: 'GeocodeInfo',
      fromJson: _fromGeocodeInfoList,
      toJson: _toGeocodeInfoList)
  final List<CommonOneMapModel> results;

  ReverseGeocode(this.results);

  factory ReverseGeocode.fromJson(Map<String, dynamic> json) =>
      _$ReverseGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$ReverseGeocodeToJson(this);

  @override
  List<Object> get props => [results];

  static List<CommonOneMapModel> _fromGeocodeInfoList(List<dynamic> data) {
    List<CommonOneMapModel> models = [];
    data.forEach((geocodeInfo) {
      models.add(CommonOneMapModel.fromGeocodeInfoModel(
          GeocodeInfo.fromJson(geocodeInfo)));
    });
    return models;
  }

  static List<dynamic> _toGeocodeInfoList(List<CommonOneMapModel> models) {
    return [];
  }
}
