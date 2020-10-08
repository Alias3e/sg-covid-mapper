import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/bottom_panel/bottom_panel.dart';
import 'package:sgcovidmapper/blocs/search/search.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';
import 'package:sgcovidmapper/blocs/update_opacity/update_opacity.dart';
import 'package:sgcovidmapper/util/constants.dart';

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController _textEditingController;
  FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchTextFieldBloc, SearchTextFieldState>(
      listener: (BuildContext context, state) {
        if (state is SearchTextFieldFocused) _focusNode.requestFocus();
        if (state is SearchTextFieldNotFocused) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: BlocBuilder<UpdateOpacityBloc, UpdateOpacityState>(
        condition: (previous, current) => current is! SpeedDialOpacityUpdating,
        builder: (BuildContext context, UpdateOpacityState state) {
          return Visibility(
            visible: state.opacity != 0,
            child: AnimatedOpacity(
              opacity: state.opacity,
              duration: Duration(milliseconds: kAnimationDuration),
              child: Focus(
                onFocusChange: (value) {
                  if (value) {
                    BlocProvider.of<SearchTextFieldBloc>(context)
                        .add(FocusSearchTextField());
                    BlocProvider.of<SearchBloc>(context).add(BeginSearch());
                  } else {
                    BlocProvider.of<SearchBloc>(context).add(SearchStopped());
                    _textEditingController.clear();
                  }
                },
                child: TextField(
                  controller: _textEditingController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).primaryColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Theme.of(context).accentColor,
                      ),
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    prefixIcon: BlocConsumer<SearchBloc, SearchState>(
                      listenWhen: (previous, current) =>
                          current is SearchResultLoaded,
                      listener: (BuildContext context, SearchState state) =>
                          BlocProvider.of<BottomPanelBloc>(context)
                              .add(SearchPanelOpenAnimationStarted()),
                      builder: (BuildContext context, SearchState state) {
                        if (state is SearchStarting ||
                            state is SearchResultLoaded)
                          return GestureDetector(
                            onTap: () {
                              BlocProvider.of<BottomPanelBloc>(context)
                                  .add(BottomPanelCollapsed());
                              BlocProvider.of<SearchBloc>(context)
                                  .add(SearchStopped());
                              FocusScope.of(context).requestFocus(FocusNode());
                              _textEditingController.clear();
                            },
                            child: Material(
                              color: Colors.transparent,
                              child: Icon(
                                Icons.close,
                                color: Theme.of(context).accentColor,
                              ),
                            ),
                          );
                        else
                          return Icon(
                            Icons.search,
                            color: Theme.of(context).primaryColor,
                          );
                      },
                    ),
                    filled: true,
                    hintStyle: new TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontSize: 16,
                        fontStyle: FontStyle.italic),
                    hintText: "Search address, buildings or postal code",
                    fillColor:
                        Theme.of(context).primaryColorLight.withAlpha(150),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty)
                      BlocProvider.of<SearchBloc>(context)
                          .add(SearchValueChanged(value));
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
