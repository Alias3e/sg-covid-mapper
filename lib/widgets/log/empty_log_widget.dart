import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/gps/gps.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';

class EmptyLogWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Theme.of(context).primaryColorLight,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You have not log any visits, either use GPS or manually search for a location to log your first visit.',
            textAlign: TextAlign.center,
            style:
                TextStyle(color: Theme.of(context).primaryColor, fontSize: 24),
          ),
          SizedBox(
            height: 24,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlatButton(
                shape: CircleBorder(),
                onPressed: () {
                  BlocProvider.of<GpsBloc>(context).add(GetGps());
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.gps_fixed,
                    color: Theme.of(context).accentColor,
                    size: 72,
                  ),
                ),
              ),
              FlatButton(
                onPressed: () {
                  BlocProvider.of<SearchTextFieldBloc>(context)
                      .add(FocusSearchTextField());
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.search,
                    color: Theme.of(context).accentColor,
                    size: 72,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
