import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel.dart';
import 'package:sgcovidmapper/blocs/map/map.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/check/check_panel.dart';

class ReverseGeocodeLocationPanel extends StatelessWidget {
  final ReverseGeocode data;

  const ReverseGeocodeLocationPanel({this.data});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomPanelBloc, BottomPanelState>(
      condition: (previous, current) => current is BottomPanelContentChanged,
      builder:
          (BuildContext context, BottomPanelState<BottomPanelStateData> state) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 500),
          child: state is BottomPanelContentChanged &&
                  state.data is CheckInPanelData
              ? CheckPanel()
              : ListView.separated(
                  itemCount: data.results.length,
                  itemBuilder: (context, index) {
                    CommonOneMapModel model = data.results[index];
                    return ListTile(
                      title: Text(
                        model.title,
                        style: Styles.kTitleTextStyle,
                      ),
                      subtitle: Text(
                        model.subtitle,
                        style: Styles.kDetailsTextStyle,
                      ),
                      trailing: IconButton(
                        icon: Icon(FontAwesomeIcons.signInAlt),
                        onPressed: () {
                          BlocProvider.of<BottomPanelBloc>(context)
                              .add(CheckInPanelSwitched(result: model));
                          BlocProvider.of<CheckPanelBloc>(context).add(
                              DisplayLocationCheckInPanel(
                                  CheckInPanelData(model, DateTime.now())));
                        },
                      ),
                      onTap: () => BlocProvider.of<MapBloc>(context).add(
                          GeoCodeLocationSelected(
                              latitude: model.latitude,
                              longitude: model.longitude)),
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) =>
                      Divider(
                    color: Colors.black12,
                  ),
                ),
        );
      },
    );
  }
}
