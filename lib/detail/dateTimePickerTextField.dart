import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateTimePickerTextField extends StatefulWidget {
  const DateTimePickerTextField({Key? key}) : super(key: key);

  @override
  _DateTimePickerTextFieldState createState() =>
      _DateTimePickerTextFieldState();
}

class _DateTimePickerTextFieldState extends State<DateTimePickerTextField> {
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
      decoration: const InputDecoration(
        hintText: 'Select date and time',
      ),
      onTap: () async {
        await _selectDate(context);
        await _selectTime(context);
      },
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
