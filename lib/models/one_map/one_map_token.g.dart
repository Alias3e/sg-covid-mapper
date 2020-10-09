// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_token.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OneMapToken _$OneMapTokenFromJson(Map<String, dynamic> json) {
  return OneMapToken(
    json['access_token'] as String,
    json['expiry_timestamp'] as String,
  );
}

Map<String, dynamic> _$OneMapTokenToJson(OneMapToken instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'expiry_timestamp': instance.expiryTimestamp,
    };
