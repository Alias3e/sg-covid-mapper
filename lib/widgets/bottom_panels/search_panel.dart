import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/util/constants.dart';
import 'package:sgcovidmapper/widgets/bottom_panels/search_results_panel.dart';
import 'package:sgcovidmapper/widgets/check/check.dart';

class SearchPanel extends StatefulWidget {
  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: BlocBuilder<SearchBloc, SearchState>(
        condition: (previous, current) => current is SearchResultLoaded,
        builder: (BuildContext context, searchState) {
          if (searchState is SearchResultLoaded) {
            return BlocBuilder<BottomPanelBloc, BottomPanelState>(
              bloc: BlocProvider.of<BottomPanelBloc>(context),
              condition: (previous, current) =>
                  current is BottomPanelContentChanged,
              builder:
                  (BuildContext context, BottomPanelState bottomPanelState) {
                return AnimatedSwitcher(
                  duration: Duration(
                    milliseconds: kAnimationDuration,
                  ),
                  child: BlocProvider.of<BottomPanelBloc>(context).panelType ==
                          PanelType.log
                      ? CheckPanel(
                          switchOutEvent: SearchPanelSwitched(),
                        )
                      : SearchResultsPanel(
                          searchState: searchState,
                        ),
                );
              },
            );
          } else {
            return Container(
              width: 0,
              height: 0,
            );
          }
        },
      ),
    );
  }
}
