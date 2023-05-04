import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerTextField extends StatefulWidget {
  const DateTimePickerTextField({Key? key, required this.initialDateTime})
      : super(key: key);
  final DateTime initialDateTime;

  @override
  _DateTimePickerTextFieldState createState() =>
      _DateTimePickerTextFieldState(initialDateTime);
}

class _DateTimePickerTextFieldState extends State<DateTimePickerTextField> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  _DateTimePickerTextFieldState(DateTime? initialDateTime) {
    if (initialDateTime != null) {
      selectedDate = initialDateTime;
      selectedTime = TimeOfDay.fromDateTime(initialDateTime);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != selectedTime) {
      setState(() {
        selectedTime = pickedTime;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: 'Select date and time',
        hintStyle: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: () async {
        await _selectDate(context);
        await _selectTime(context);
      },
      style: Theme.of(context).textTheme.titleLarge,
      controller: TextEditingController(
        text: selectedDate != null && selectedTime != null
            ? DateFormat.yMd().add_jm().format(DateTime(
                selectedDate!.year,
                selectedDate!.month,
                selectedDate!.day,
                selectedTime!.hour,
                selectedTime!.minute))
            : '',
      ),
    );
  }
}
