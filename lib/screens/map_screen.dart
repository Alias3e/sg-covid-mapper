import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/cluster_widget.dart';
import 'package:sgcovidmapper/widgets/map_screen_speed_dial.dart';
import 'package:sgcovidmapper/widgets/place_details_widget.dart';
import 'package:sgcovidmapper/widgets/search_result_sheet.dart';
import 'package:sgcovidmapper/widgets/search_text_field.dart';

class MapScreen extends StatelessWidget {
  final MapController mapController;

  const MapScreen({this.mapController}) : assert(mapController != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent markers from being shifted by keyboard.
      resizeToAvoidBottomInset: false,
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        condition: (previous, current) =>
            current is GpsLocationAcquiring ||
            current is MapViewBoundsChanged ||
            current is GpsLocationFailed,
        builder: (BuildContext context, state) => MapScreenSpeedDial(),
      ),
      body: Stack(
        children: [
          BlocConsumer<MapBloc, MapState>(
            listenWhen: (previous, current) =>
                current is MapViewBoundsChanged ||
                (previous is PlacesLoading && current is MapUpdated),
            listener: (context, state) async {
              if (state is MapViewBoundsChanged) {
                mapController.move(state.mapCenter, MapConstants.maxZoom);
              }
              if (state is MapUpdated) {
                LatLngBounds bounds = LatLngBounds.fromPoints(
                    state.covidPlaces.map((e) => e.point).toList());
                mapController.fitBounds(bounds);
              }
            },
            builder: (BuildContext context, state) {
              return FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: MapConstants.mapCenter,
                  zoom: MapConstants.zoom,
                  maxZoom: MapConstants.maxZoom,
                  minZoom: MapConstants.minZoom,
                  plugins: [
                    MarkerClusterPlugin(),
                  ],
                ),
                layers: [
                  MapConstants.tileLayerOptions,
                  MarkerLayerOptions(markers: state.nearbyPlaces),
                  MarkerClusterLayerOptions(
                    maxClusterRadius: 60,
                    size: Size(50, 50),
                    anchor: AnchorPos.align(AnchorAlign.center),
                    showPolygon: false,
                    fitBoundsOptions: FitBoundsOptions(
                      padding: EdgeInsets.all(50),
                    ),
                    onMarkerTap: (Marker marker) =>
                        _showPlaceBottomSheet(context, [marker]),
                    onClusterTap: (node) {
                      if (node.bounds.east == node.bounds.west &&
                          node.bounds.north == node.bounds.south) {
                        _showPlaceBottomSheet(
                            context,
                            node.markers
                                .map((e) => e.marker as PlaceMarker)
                                .toList());
                      }
                    },
                    computeSize: (markers) {
                      double size = (log(markers.length)) * 25.0 + 15;
                      return Size(size, size);
                    },
                    markers: state.covidPlaces,
                    builder: (context, markers) {
                      return ClusterWidget(
                        markers: markers,
                      );
                    },
                  ),
                ],
              );
            },
          ),
          SearchResultSheet(),
          Positioned(
            top: 12.0,
            left: 24.0,
            right: 24.0,
            child: SafeArea(
              child: SearchTextField(),
            ),
          ),
        ],
      ),
    );
  }

  _showPlaceBottomSheet(BuildContext context, List<PlaceMarker> markers) {
    PersistentBottomSheetController controller;
    controller = showBottomSheet(
        backgroundColor: Colors.teal,
        context: context,
        builder: (context) {
          return PlaceDetailsWidget(
            markers: markers,
            bottomSheetController: controller,
          );
        });
  }
}
