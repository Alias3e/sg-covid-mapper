import 'package:json_annotation/json_annotation.dart';

part 'one_map_token.g.dart';

@JsonSerializable()
class OneMapToken {
  @JsonKey(name: 'access_token')
  final String accessToken;

  @JsonKey(name: 'expiry_timestamp')
  final String expiryTimestamp;

  OneMapToken(this.accessToken, this.expiryTimestamp);

  factory OneMapToken.fromJson(Map<String, dynamic> json) =>
      _$OneMapTokenFromJson(json);

  Map<String, dynamic> toJson() => _$OneMapTokenToJson(this);
}
