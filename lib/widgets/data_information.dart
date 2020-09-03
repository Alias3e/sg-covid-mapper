import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/repositories/covid_places_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class DataInformation extends StatelessWidget {
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
            duration: Duration(milliseconds: 250),
            opacity: state.opacity,
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColorLight.withAlpha(150),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Theme.of(context).accentColor.withAlpha(150),
                  ),
                  SizedBox(
                    width: 12,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'View moh.gov.sg source data',
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .accentColor
                                      .withAlpha(150),
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  // do something here
                                  String url = RepositoryProvider.of<
                                          CovidPlacesRepository>(context)
                                      .source;
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'App updated on ${RepositoryProvider.of<CovidPlacesRepository>(context).dataUpdated}',
                        style: TextStyle(color: Colors.black.withAlpha(150)),
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
