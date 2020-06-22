import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/blocs/search/search_event.dart';
import 'package:sgcovidmapper/util/constants.dart';

class SearchTextField extends StatefulWidget {
  @override
  _SearchTextFieldState createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  TextEditingController _textEditingController;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (value) {
        if (value) BlocProvider.of<SearchBloc>(context).add(BeginSearch());
      },
      child: TextField(
        controller: _textEditingController,
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Styles.kSearchTextFieldGrayColor,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.teal,
            ),
            borderRadius: const BorderRadius.all(
              const Radius.circular(30.0),
            ),
          ),
          prefixIcon: BlocBuilder<SearchBloc, SearchState>(
            builder: (BuildContext context, SearchState state) {
              if (state is SearchStarting || state is SearchResultLoaded)
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    customBorder: new CircleBorder(),
                    onTap: () {
                      BlocProvider.of<SearchBloc>(context).add(StopSearch());
                      FocusScope.of(context).requestFocus(FocusNode());
                      _textEditingController.clear();
                    },
                    child: Icon(
                      Icons.close,
                      color: Styles.kSearchTextFieldGrayColor,
                    ),
                  ),
                );
              else
                return Container(
                  width: 0,
                  height: 0,
                );
            },
          ),
          filled: true,
          hintStyle: new TextStyle(
              color: Styles.kSearchTextFieldGrayColor,
              fontSize: 16,
              fontStyle: FontStyle.italic),
          hintText: "Search location",
          fillColor:
              Color.fromARGB(Color.getAlphaFromOpacity(0.6), 255, 255, 255),
        ),
        onChanged: (value) {
          if (value.isNotEmpty)
            BlocProvider.of<SearchBloc>(context).add(SearchUpdated(value));
        },
      ),
    );
  }
}
