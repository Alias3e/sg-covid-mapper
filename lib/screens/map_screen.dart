import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/blocs/warning/warning.dart';
import 'package:sgcovidmapper/models/models.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/alerts_dialog.dart';
import 'package:sgcovidmapper/widgets/data_information.dart';
import 'package:sgcovidmapper/widgets/showcase_container.dart';
import 'package:sgcovidmapper/widgets/widgets.dart';
import 'package:showcaseview/showcase.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  MapController _mapController;
  PanelController _panelController;
  Key searchKey;
  Key speedDialKey;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _panelController = PanelController();
    searchKey = GlobalKey();
    speedDialKey = GlobalKey();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_panelController.isPanelOpen) {
          _panelController.close();
          return false;
        }
        Platform.isAndroid ? SystemNavigator.pop() : exit(0);
        return false;
      },
      child: BlocListener<WarningBloc, WarningState>(
        condition: (previous, current) => current is DisplayAlerts,
        listener: (BuildContext context, state) =>
            SchedulerBinding.instance.addPostFrameCallback((_) async {
          await Future.delayed(Duration(milliseconds: 500));
          AlertsDialog.showAlertDialog(
              (state as DisplayAlerts).alerts, context);
        }),
        child: Scaffold(
          // Prevent markers from being shifted by keyboard.
          resizeToAvoidBottomInset: true,
          floatingActionButton: MapScreenSpeedDial(),
          body: Stack(
            children: [
              BlocConsumer<BottomPanelBloc, BottomPanelState>(
                listener: (BuildContext context, BottomPanelState state) {
                  if (state is PanelPositionUpdated) return;
                  if (state is BottomPanelContentChanged) {
                    _panelController.animatePanelToPosition(
                      state.maxHeight,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                  if (state is BottomPanelOpening) {
                    _panelController.animatePanelToPosition(
                      1.0,
                      duration: Duration(milliseconds: 250),
                      curve: Curves.linear,
                    );
                  }
                  if (state is BottomPanelClosing) {
                    _panelController.animatePanelToPosition(0.0,
                        duration: Duration(milliseconds: 250),
                        curve: Curves.linear);
                  }
                },
                buildWhen: (previous, current) =>
                    (current is BottomPanelOpening ||
                        current is BottomPanelOpened ||
                        current is BottomPanelCollapsed),
                builder: (BuildContext context, BottomPanelState state) {
                  return SlidingUpPanel(
                    color: Theme.of(context).primaryColorLight,
                    isDraggable:
                        state.isDraggable != null ? state.isDraggable : false,
                    panelSnapping: true,
                    parallaxEnabled: true,
                    parallaxOffset: 0.5,
                    controller: _panelController,
                    backdropEnabled: true,
                    backdropOpacity: 0.05,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18.0),
                        topRight: Radius.circular(18.0)),
                    backdropTapClosesPanel: true,
                    minHeight: 0.00,
                    maxHeight:
                        MediaQuery.of(context).size.height * state.maxHeight,
                    onPanelOpened: () {
                      if (state.data is SearchPanelData)
                        BlocProvider.of<BottomPanelBloc>(context)
                            .add(SearchPanelOpened());
                      if (state.data is PlacePanelData)
                        BlocProvider.of<BottomPanelBloc>(context)
                            .add(PlacePanelOpened());
                      if (state.data is GeocodePanelData)
                        BlocProvider.of<MapBloc>(context)
                            .add(DisplayUserLocation());
                    },
                    onPanelClosed: () {
                      BlocProvider.of<BottomPanelBloc>(context)
                          .add(OnBottomPanelClosed());
                      if (state.data is SearchPanelData ||
                          state.data is GeocodePanelData)
                        BlocProvider.of<MapBloc>(context)
                            .add(ClearOneMapPlacesMarker());
                    },
                    onPanelSlide: (position) {
                      BlocProvider.of<BottomPanelBloc>(context).add(
                          PanelPositionChanged(
                              position: position, data: state.data));
                    },
//                    state is BottomPanelOpened && state.data is PlacePanelData
//                        ? _onBottomPanelSlide
//                        : null,
                    panelBuilder: (sc) => BottomPanel(
                      state: state,
                      scrollController: sc,
                    ),
                    body: BlocConsumer<MapBloc, MapState>(
                      listenWhen: (previous, current) =>
                          current is MapViewBoundsChanged ||
                          (previous is PlacesLoading && current is MapUpdated),
                      listener: (context, state) async {
                        if (state is MapViewBoundsChanged) {
                          _animatedMapMove(
                              state.mapCenter, MapConstants.maxZoom);
                        }
                        if (state is MapUpdated) {
                          LatLngBounds bounds = LatLngBounds.fromPoints(
                              state.covidPlaces.map((e) => e.point).toList());
                          _mapController.fitBounds(bounds);
                        }
                      },
                      builder: (BuildContext context, MapState state) {
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
                                  BlocProvider.of<BottomPanelBloc>(context)
                                      .add(PlacePanelDisplayed([marker])),
                              onClusterTap: (node) {
                                BlocProvider.of<BottomPanelBloc>(context).add(
                                    PlacePanelDisplayed(node.markers
                                        .map((e) => e.marker as PlaceMarker)
                                        .toList()));
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
                  );
                },
              ),
//          SearchResultSheet(),
              DataInformation(
                keys: [searchKey],
              ),
              Positioned(
                top: 12.0,
                left: 24.0,
                right: 24.0,
                child: SafeArea(
                  child: Showcase.withWidget(
                    key: searchKey,
                    height: 200,
                    width: 250,
                    shapeBorder: CircleBorder(),
                    container: ShowcaseContainer(
                      height: 160,
                      width: 379.5,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  'Search building, addresses or postal code. '
                                  'Clicking on a result will zoom to the location. '
                                  'Search is powered by OneMap.sg.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8),
                                child: Icon(
                                  FontAwesomeIcons.signInAlt,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              SizedBox(
                                width: 8,
                              ),
                              Expanded(
                                child: Text(
                                  'You can add a location to your visit log by '
                                  'clicking on the check in button in the search result.',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    child: SearchTextField(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

//  _getBottomPanel(BottomPanelState state, ScrollController scrollController) {
//    if (state is BottomPanelOpening) {
//      BottomPanelStateData data = state.data;
//      if (data is SearchPanelData) return SearchPanel();
//      if (data is PlacePanelData)
//        return PlacesPanel(
//          markers: data.markers,
//          scrollController: scrollController,
//        );
//    }
//
//    if (state is BottomPanelOpened) {
//      BottomPanelStateData data = state.data;
//      if (data is PlacePanelData)
//        return PlacesPanel(
//          markers: data.markers,
//          scrollController: scrollController,
//        );
//    }
//
//    return Container(
//      width: 0,
//      height: 0,
//    );
//  }

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
