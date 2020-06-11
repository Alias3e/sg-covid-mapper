import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';

class MapScreen extends StatelessWidget {
  final MapController mapController;

  const MapScreen({Key key, this.mapController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: BlocBuilder<MapBloc, MapState>(
        condition: (previous, current) =>
            current is GpsLocationAcquiring || current is GpsLocationUpdated,
        builder: (BuildContext context, state) {
          return FloatingActionButton(
            child: state is GpsLocationAcquiring
                ? SpinKitDualRing(
                    color: Colors.white,
                    size: 35.0,
                    lineWidth: 4.0,
                  )
                : Icon(Icons.gps_fixed),
            onPressed: () {
              BlocProvider.of<MapBloc>(context).add(GetGPS());
            },
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
                size: Size(55, 55),
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
                markers: state is MapState ? state.places : [],
                builder: (context, markers) {
                  return Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.teal, shape: BoxShape.circle),
                        ),
                      ),
                      Center(
                        child: FaIcon(
                          FontAwesomeIcons.viruses,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 1,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.teal,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          child: Padding(
                            padding: markers.length < 10
                                ? EdgeInsets.all(4)
                                : EdgeInsets.all(2),
                            child: Text(
//                                '99',
                              markers.length < 100
                                  ? markers.length.toString()
                                  : '99',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ),
                      ),
                    ],
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
