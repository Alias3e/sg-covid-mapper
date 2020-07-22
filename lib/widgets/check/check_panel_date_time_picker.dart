import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class CheckPanelDateTimePicker extends StatelessWidget {
  final Function onChange;

  const CheckPanelDateTimePicker({@required this.onChange});

  @override
  Widget build(BuildContext context) {
    return DateTimePickerWidget(
      pickerTheme: DateTimePickerTheme(
        showTitle: false,
        itemHeight: 50,
        pickerHeight: 120,
      ),
      minDateTime: DateTime.now().subtract(Duration(days: 15)),
      dateFormat: 'dd/MM/yyyy, HH:mm',
      onChange: onChange,
    );
  }
}
