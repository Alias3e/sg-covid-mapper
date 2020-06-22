import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'one_map_search_result.g.dart';

@JsonSerializable()
class OneMapSearchResult extends Equatable {
  @JsonKey(name: 'SEARCHVAL')
  final String searchValue;

  @JsonKey(name: 'POSTAL')
  final String postalCode;

  @JsonKey(name: 'LATITUDE')
  final String latitude;

  @JsonKey(name: 'LONGITUDE')
  final String longitude;

  @JsonKey(name: 'ADDRESS')
  final String address;

  OneMapSearchResult({
    this.searchValue,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.address,
  });

  factory OneMapSearchResult.fromJson(Map<String, dynamic> json) =>
      _$OneMapSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$OneMapSearchResultToJson(this);

  @override
  // TODO: implement props
  List<Object> get props =>
      [searchValue, postalCode, latitude, longitude, address];
}
