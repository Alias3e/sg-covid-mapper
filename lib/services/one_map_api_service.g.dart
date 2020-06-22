// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'one_map_api_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _OneMapApiService implements OneMapApiService {
  _OneMapApiService(this._dio, {this.baseUrl}) {
    ArgumentError.checkNotNull(_dio, '_dio');
    this.baseUrl ??= 'https://developers.onemap.sg/';
  }

  final Dio _dio;

  String baseUrl;

  @override
  search(queries) async {
    ArgumentError.checkNotNull(queries, 'queries');
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries ?? <String, dynamic>{});
    final _data = <String, dynamic>{};
    final Response<Map<String, dynamic>> _result = await _dio.request(
        'commonapi/search',
        queryParameters: queryParameters,
        options: RequestOptions(
            method: 'GET',
            headers: <String, dynamic>{},
            extra: _extra,
            baseUrl: baseUrl),
        data: _data);
    final value = OneMapSearch.fromJson(_result.data);
    return value;
  }
}
