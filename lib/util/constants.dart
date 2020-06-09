import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:intl/intl.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/util/config.dart';

enum BaseMap {
  OneMap,
  MapTiler,
  OSM,
}

class MapConstants {
  static BaseMap baseMap = BaseMap.OSM;
  static const double zoom = 12.5;
  static final LatLng mapCenter = LatLng(1.354, 103.82);

  static const Map<BaseMap, double> _maxZoomMap = {
    BaseMap.OneMap: 18,
    BaseMap.MapTiler: 20,
    BaseMap.OSM: 20,
  };

  static const Map<BaseMap, double> _minZoomMap = {
    BaseMap.OneMap: 11.5,
    BaseMap.MapTiler: 11.5,
    BaseMap.OSM: 11.5,
  };

  static const Map<BaseMap, String> _tileUrl = {
    BaseMap.OneMap: 'https://maps-{s}.onemap.sg/v3/Grey/{z}/{x}/{y}.png',
    BaseMap.MapTiler:
        'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key={key}',
    BaseMap.OSM: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  };

  static double get maxZoom {
    if (baseMap == BaseMap.OSM) return _maxZoomMap[baseMap];
    if (baseMap == BaseMap.MapTiler) return _maxZoomMap[baseMap];
    return _maxZoomMap[baseMap];
  }

  static double get minZoom {
    if (baseMap == BaseMap.OSM) return _minZoomMap[baseMap];
    if (baseMap == BaseMap.MapTiler) return _minZoomMap[baseMap];
    return _minZoomMap[baseMap];
  }

  static TileLayerOptions get tileLayerOptions {
    switch (baseMap) {
      case BaseMap.MapTiler:
        return TileLayerOptions(
          urlTemplate: _tileUrl[baseMap],
          additionalOptions: {'key': Config.configurations['map_tileset_key']},
          maxZoom: maxZoom,
          minZoom: minZoom,
        );
        break;
      default:
        return TileLayerOptions(
          urlTemplate: _tileUrl[baseMap],
          subdomains: ['a', 'b', 'c'],
          maxZoom: maxZoom,
          minZoom: minZoom,
        );
        break;
    }
  }
}

class Styles {
  static const TextStyle kTitleTextStyle = TextStyle(
    fontSize: 24,
    color: Colors.teal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle kDetailsTextStyle = TextStyle(
    fontSize: 16,
    color: Colors.white,
  );

  static final DateFormat kStartDateFormat = DateFormat("dd/MM/yyyy HH:mm");

  static final DateFormat kEndTimeFormat = DateFormat("HH:mm");
}
