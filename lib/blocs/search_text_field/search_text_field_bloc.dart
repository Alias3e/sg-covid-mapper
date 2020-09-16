import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sgcovidmapper/blocs/search_text_field/search_text_field.dart';

class SearchTextFieldBloc
    extends Bloc<SearchTextFieldEvent, SearchTextFieldState> {
  @override
  SearchTextFieldState get initialState => SearchTextFieldNotFocused();

  @override
  Stream<SearchTextFieldState> mapEventToState(
      SearchTextFieldEvent event) async* {
    if (event is FocusSearchTextField) yield SearchTextFieldFocused();

    if (event is SearchTextFieldLoseFocus) yield SearchTextFieldNotFocused();
  }
}
