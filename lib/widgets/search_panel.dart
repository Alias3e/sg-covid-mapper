import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/check_panel/check_panel_bloc.dart';
import 'package:sgcovidmapper/widgets/search_results_panel.dart';

import 'check_panel.dart';

class SearchPanel extends StatefulWidget {
  @override
  _SearchPanelState createState() => _SearchPanelState();
}

class _SearchPanelState extends State<SearchPanel> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                  return BlocProvider<CheckPanelBloc>(
                    create: (BuildContext context) => CheckPanelBloc(),
                    child: AnimatedSwitcher(
                      duration: Duration(
                        milliseconds: 500,
                      ),
                      child: bottomPanelState is BottomPanelContentChanged &&
                              bottomPanelState.data is CheckInPanelData
                          ? CheckPanel()
                          : SearchResultsPanel(
                              searchState: searchState,
                            ),
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
      ),
    );
  }
}
