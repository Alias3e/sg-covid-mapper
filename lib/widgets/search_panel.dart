import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong/latlong.dart';
import 'package:sgcovidmapper/blocs/blocs.dart';
import 'package:sgcovidmapper/models/one_map_search_result.dart';

class SearchPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: BlocBuilder<SearchBloc, SearchState>(
        condition: (previous, current) => current is SearchResultLoaded,
        builder: (BuildContext context, state) {
          if (state is SearchResultLoaded) {
            return ListView.separated(
              scrollDirection: Axis.vertical,
              itemCount: state.result != null ? state.result.count : 0,
              itemBuilder: (BuildContext context, int index) {
                OneMapSearchResult result = state.result.results[index];
                return ListTile(
                  title: Text('${result.searchValue}'),
                  subtitle: Text('${result.address}'),
                  trailing: IconButton(
                    icon: Icon(Icons.event),
                    onPressed: () => print('Tapped!!'),
                  ),
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                    BlocProvider.of<MapBloc>(context).add(CenterOnLocation(
                        location: LatLng(result.latitude, result.longitude)));
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: Colors.black12,
              ),
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
