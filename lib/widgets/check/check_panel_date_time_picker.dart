import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class CheckPanelDateTimePicker extends StatelessWidget {
  final Function onChange;
  final DateTime initialDateTime;

  const CheckPanelDateTimePicker(
      {@required this.onChange, this.initialDateTime});

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        itemHeight: 50,
        pickerHeight: 120,
      ),
      initDateTime: initialDateTime,
      minDateTime: DateTime.now().subtract(Duration(days: 15)),
      dateFormat: 'dd/MM/yyyy, HH:mm',
      onChange: onChange,
    );
  }
}
