import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sgcovidmapper/models/one_map/one_map_search.dart';
import 'package:sgcovidmapper/models/one_map/one_map_token.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/services/map_service.dart';

part 'one_map_api_service.g.dart';

@RestApi(baseUrl: 'https://developers.onemap.sg/')
abstract class OneMapApiService extends GeocodeService {
  factory OneMapApiService(Dio dio, {String baseUrl}) = _OneMapApiService;

  @override
  @GET('commonapi/search')
  Future<OneMapSearch> search(@Queries() Map<String, dynamic> queries);

  @GET('privateapi/commonsvc/revgeocode')
  Future<ReverseGeocode> reverseGeocode(
      {@Query('token') token,
      @Query('location') location,
      @Query('buffer') buffer});

  @override
  @POST('privateapi/auth/post/getToken')
  Future<OneMapToken> authenticate(
      {@Field() String email, @Field() String password});
}
