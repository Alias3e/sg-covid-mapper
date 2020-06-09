import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
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
        listenWhen: (previous, current) => current is GpsLocationUpdated,
        listener: (context, state) {
          if (state is GpsLocationUpdated) {
            mapController.move(state.currentGpsPosition, MapConstants.maxZoom);
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
                onMarkerTap: (marker) => print(marker.toString()),
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
}
