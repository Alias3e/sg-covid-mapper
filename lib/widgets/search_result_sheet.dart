import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';

class SearchResultSheet extends StatefulWidget {
  @override
  _SearchResultSheetState createState() => _SearchResultSheetState();
}

class _SearchResultSheetState extends State<SearchResultSheet>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Duration _duration = Duration(milliseconds: 250);
  Tween<Offset> _tween = Tween(begin: Offset(0, 1), end: Offset(0, 0));

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _duration);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SearchBloc, SearchState>(
      listener: (BuildContext context, state) async {
        if (state is SearchStarting) _controller.forward();
        if (state is SearchEmpty) _controller.reverse();
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SizedBox.expand(
          child: SlideTransition(
            position: _tween.animate(_controller),
            child: DraggableScrollableSheet(
              initialChildSize: 1.0,
              minChildSize: 0,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return Container(
                  padding: EdgeInsets.only(top: 80),
                  color: Colors.white,
                  child: BlocBuilder<SearchBloc, SearchState>(
                    condition: (previous, current) =>
                        current is SearchResultLoaded,
                    builder: (BuildContext context, state) {
                      if (state is SearchResultLoaded) {
                        return ListView.builder(
                            controller: scrollController,
                            itemCount:
                                state.result != null ? state.result.count : 0,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                title: Text(
                                    '${state.result.results[index].searchValue}'),
                                subtitle: Text(
                                    '${state.result.results[index].address}'),
                              );
                            });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
