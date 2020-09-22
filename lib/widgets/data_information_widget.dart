import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/data_information/data_information.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:showcaseview/showcase_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class DataInformationWidget extends StatefulWidget {
  final List<GlobalKey> keys;

  const DataInformationWidget({this.keys});

  @override
  _DataInformationWidgetState createState() => _DataInformationWidgetState();
}

class _DataInformationWidgetState extends State<DataInformationWidget> {
  String url = 'https://www.moh.gov.sg/';
  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 18,
      left: 16,
      child: BlocBuilder<UpdateOpacityBloc, UpdateOpacityState>(
        condition: (previous, current) => current is! SearchBoxOpacityUpdating,
        builder: (context, state) => Visibility(
          visible: state.opacity != 0,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: kAnimationDuration),
            opacity: state.opacity,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight.withAlpha(150),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () =>
                        ShowCaseWidget.of(context).startShowCase(widget.keys),
                    child: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).accentColor.withAlpha(150),
                    ),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BlocListener<DataInformationBloc, DataInformationState>(
                        listener: (context, state) {
                          if (state is DataInformationUpdated)
                            url = state.map['source'];
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Source data courtesy of moh.gov.sg',
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .accentColor
                                        .withAlpha(150),
                                    decoration: TextDecoration.underline),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () async {
                                    // do something here
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url}';
                                    }
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                      BlocBuilder<DataInformationBloc, DataInformationState>(
                        builder: (context, state) => Text(
                          state is DataInformationUpdated
                              ? 'App data updated on ${state.map['updated']}'
                              : '',
                          style: TextStyle(color: Colors.black.withAlpha(150)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
