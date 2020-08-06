import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sgcovidmapper/models/one_map/common_one_map_model.dart';
import 'package:sgcovidmapper/models/one_map/reverse_geocode.dart';
import 'package:sgcovidmapper/util/constants.dart';

class ReverseGeocodeLocationPanel extends StatelessWidget {
  final ReverseGeocode data;

  const ReverseGeocodeLocationPanel({this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
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
              return;
            },
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) => Divider(
        color: Colors.black12,
      ),
    );
  }
}
