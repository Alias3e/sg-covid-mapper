import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/cluster_widget.dart';
import 'package:sgcovidmapper/widgets/map_screen_fab.dart';

class MapScreen extends StatelessWidget {
  final MapController mapController;

  const MapScreen({this.mapController}) : assert(mapController != null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        condition: (previous, current) =>
            current is GpsLocationAcquiring ||
            current is GpsLocationUpdated ||
            current is GpsLocationFailed,
        builder: (BuildContext context, state) {
          return MapScreenFAB(
            state: state,
          );
        },
      ),
      body: BlocConsumer<MapBloc, MapState>(
        listenWhen: (previous, current) =>
            current is GpsLocationUpdated ||
            (previous is PlacesLoading && current is PlacesUpdated),
        listener: (context, state) {
          if (state is GpsLocationUpdated) {
            mapController.move(state.currentGpsPosition, MapConstants.maxZoom);
          }
          if (state is PlacesUpdated) {
            LatLngBounds bounds = LatLngBounds.fromPoints(
                state.places.map((e) => e.point).toList());
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
              new MarkerLayerOptions(
                  markers:
                      state is GpsLocationUpdated ? [state.gpsMarker] : []),
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
                markers: state is MapState ? state.places : [],
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
    );
  }

  _showPlaceBottomSheet(BuildContext context, List<PlaceMarker> markers) {
    PersistentBottomSheetController controller;
    PlaceMarker marker = markers[0];
    List<Widget> widgets = [];
    widgets.add(
      Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            GestureDetector(
              onTap: () => controller.close(),
              child: Container(
                padding: EdgeInsets.only(top: 10.0, bottom: 4.0),
                width: double.infinity,
                child: Center(
                  child: FaIcon(
                    FontAwesomeIcons.angleDoubleDown,
                    color: Colors.teal,
                    size: 20,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 8.0),
              child: Text(
                marker.title,
                style: Styles.kTitleTextStyle,
              ),
            ),
          ],
        ),
      ),
    );
    widgets.add(SizedBox(height: 16.0));

    for (PlaceMarker currentMarker in markers) {
      if (marker.subLocation.isNotEmpty) {
        widgets.add(
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
            child: Text(
              currentMarker.subLocation,
              style: Styles.kDetailsTextStyle,
            ),
          ),
        );
      }
      widgets.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 16.0),
          child: Text(
            '${Styles.kStartDateFormat.format(currentMarker.startDate.toDate())} - ${Styles.kEndTimeFormat.format(currentMarker.endDate.toDate())}',
            style: Styles.kDetailsTextStyle,
          ),
        ),
      );
    }

    controller = showBottomSheet(
        backgroundColor: Colors.teal,
        context: context,
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          );
        });
  }
}
