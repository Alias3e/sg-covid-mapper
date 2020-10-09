import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:sgcovidmapper/models/one_map/geocode_info.dart';
import 'package:sgcovidmapper/models/one_map/one_map.dart';

class CommonOneMapModel extends Equatable {
  final double latitude;
  final double longitude;
  final String tempTitle;
  final String subtitle;
  final String postalCode;

  CommonOneMapModel({
    @required this.latitude,
    @required this.longitude,
    @required this.tempTitle,
    @required this.subtitle,
    @required this.postalCode,
  });

  String get title => tempTitle == 'null' ? subtitle : tempTitle;

  factory CommonOneMapModel.fromSearchResultModel(OneMapSearchResult model) =>
      CommonOneMapModel(
        tempTitle: model.searchValue,
        subtitle: model.address,
        postalCode: model.postalCode,
        latitude: model.latitude,
        longitude: model.longitude,
      );

  factory CommonOneMapModel.fromGeocodeInfoModel(GeocodeInfo model) =>
      CommonOneMapModel(
          latitude: model.latitude,
          longitude: model.longitude,
          tempTitle: model.buildingName,
          subtitle: 'Block ${model.block} ${model.road} ${model.postalCode}',
          postalCode: model.postalCode);

  @override
  List<Object> get props => [latitude, longitude, title, subtitle, postalCode];
}
