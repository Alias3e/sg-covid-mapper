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
  final String latitudeString;

  @JsonKey(name: 'LONGITUDE')
  final String longitudeString;

  @JsonKey(name: 'ADDRESS')
  final String address;

  OneMapSearchResult({
    this.searchValue,
    this.postalCode,
    this.latitudeString,
    this.longitudeString,
    this.address,
  });

  factory OneMapSearchResult.fromJson(Map<String, dynamic> json) =>
      _$OneMapSearchResultFromJson(json);

  Map<String, dynamic> toJson() => _$OneMapSearchResultToJson(this);

  double get latitude => double.parse(latitudeString);

  double get longitude => double.parse(longitudeString);

  @override
  // TODO: implement props
  List<Object> get props =>
      [searchValue, postalCode, latitudeString, longitudeString, address];
}
