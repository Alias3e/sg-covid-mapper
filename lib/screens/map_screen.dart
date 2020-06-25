import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/widgets.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

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
                _animatedMapMove(state.mapCenter, MapConstants.maxZoom);
              }
              if (state is MapUpdated) {
                LatLngBounds bounds = LatLngBounds.fromPoints(
                    state.covidPlaces.map((e) => e.point).toList());
                _mapController.fitBounds(bounds);
              }
            },
            builder: (BuildContext context, state) {
              return FlutterMap(
                mapController: _mapController,
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

  void _animatedMapMove(LatLng destLocation, double destZoom) {
    // Create some tweens. These serve to split up the transition from one location to another.
    // In our case, we want to split the transition be<tween> our current map center and the destination.
    final _latTween = Tween<double>(
        begin: _mapController.center.latitude, end: destLocation.latitude);
    final _lngTween = Tween<double>(
        begin: _mapController.center.longitude, end: destLocation.longitude);
    final _zoomTween = Tween<double>(begin: _mapController.zoom, end: destZoom);

    // Create a animation controller that has a duration and a TickerProvider.
    var controller = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // The animation determines what path the animation will take. You can try different Curves values, although I found
    // fastOutSlowIn to be my favorite.
    Animation<double> animation =
        CurvedAnimation(parent: controller, curve: Curves.fastOutSlowIn);

    controller.addListener(() {
      _mapController.move(
          LatLng(_latTween.evaluate(animation), _lngTween.evaluate(animation)),
          _zoomTween.evaluate(animation));
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        controller.dispose();
      } else if (status == AnimationStatus.dismissed) {
        controller.dispose();
      }
    });

    controller.forward();
  }
}
