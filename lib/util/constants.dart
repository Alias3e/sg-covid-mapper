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
  static const double zoom = 10;
  static final LatLng mapCenter = LatLng(1.354, 103.82);

  static const Map<BaseMap, double> _maxZoomMap = {
    BaseMap.OneMap: 18,
    BaseMap.MapTiler: 20,
    BaseMap.OSM: 20,
  };

  static const Map<BaseMap, double> _minZoomMap = {
    BaseMap.OneMap: 10.5,
    BaseMap.MapTiler: 10.5,
    BaseMap.OSM: 10.5,
  };

  static const Map<BaseMap, String> _tileUrl = {
    BaseMap.OneMap: 'https://maps-{s}.onemap.sg/v3/Grey/{z}/{x}/{y}.png',
    BaseMap.MapTiler:
        'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key={key}',
    BaseMap.OSM: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
  };

  static double get maxZoom => _maxZoomMap[baseMap];

  static double get minZoom => _minZoomMap[baseMap];

  static TileLayerOptions get tileLayerOptions {
    switch (baseMap) {
      case BaseMap.MapTiler:
        return TileLayerOptions(
          urlTemplate: _tileUrl[baseMap],
          additionalOptions: {'key': Asset.configurations['map_tileset_key']},
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
    color: Colors.black,
  );

  static const TextStyle kSelectedTitleTextStyle = TextStyle(
    color: AppColors.kColorPrimary,
    fontWeight: FontWeight.w900,
  );

  static const TextStyle kDetailsTextStyle = TextStyle(
    color: Colors.black54,
  );

  static final TextStyle kSelectedDetailsTextStyle = TextStyle(
    color: AppColors.kColorPrimaryLight, // Teal[200]
  );

  static final DateFormat kStartDateFormat = DateFormat("dd/MM/yyyy HH:mm");

  static final DateFormat kEndTimeFormat = DateFormat("HH:mm");

  static final DateFormat kLogTileDateFormat = DateFormat("dd MMM");

  static final DateFormat kUpdatedDateFormat = DateFormat("dd MMM HH:mm");

  static final Color kSearchTextFieldGrayColor =
      Color.fromARGB(Color.getAlphaFromOpacity(0.6), 111, 111, 111);
}

class Keys {
  static const Key kKeyFABSpinner = Key('key_fab_spinner');
  static const Key kKeySubLocationText = Key('key_sub_location_text');
}

class AppColors {
  static const MaterialColor kColorPrimary = Colors.deepPurple;
  static const MaterialColor kColorAccent = Colors.deepOrange;
  static final Color kColorPrimaryLight = Colors.deepPurple[200];
  static final Color kColorAccentLight = Colors.deepOrange[200];
  static final Color kColorAccentDark = Colors.deepOrange[600];
  static final Color kColorRed = Colors.red;
  static final Color kColorGreen = Colors.teal;
}

int kAnimationDuration = 225;
