import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class BirthDatePicker extends StatefulWidget {
  final void Function(DateTime) onDateTimeChanged;
  final String initDateStr;

  BirthDatePicker({
    required this.onDateTimeChanged,
    required this.initDateStr,
  });

  @override
  State<BirthDatePicker> createState() => _BirthDatePickerState();
}

class _BirthDatePickerState extends State<BirthDatePicker> {
  @override
  Widget build(BuildContext context) {
    final initDate = DateFormat('yyyy-MM-dd').parse(widget.initDateStr);
    return SizedBox(
      height: 300,
      child: CupertinoDatePicker(
        minimumYear: 1900,
        maximumYear: DateTime.now().year,
        initialDateTime: initDate,
        maximumDate: DateTime.now(),
        onDateTimeChanged: widget.onDateTimeChanged,
        mode: CupertinoDatePickerMode.date,
      ),
    );
  }
}
