import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateButton extends StatefulWidget {
  final Function(DateTime) onDateChanged;

  const DateButton({super.key, required this.onDateChanged});

  @override
  _DateButtonState createState() => _DateButtonState();
}

class _DateButtonState extends State<DateButton> {
  DateTime selectedDate = DateTime.now().toLocal();

  void _selectPreviousDay() {
    setState(() {
      selectedDate = selectedDate.subtract(const Duration(days: 1));
      widget.onDateChanged(selectedDate);
    });
  }

  void _selectNextDay() {
    setState(() {
      selectedDate = selectedDate.add(const Duration(days: 1));
      widget.onDateChanged(selectedDate);
    });
  }

  void _selectPreviousMonth() {
    setState(() {
      if (selectedDate.month == 1) {
        selectedDate = DateTime(selectedDate.year - 1, 12, selectedDate.day);
      } else {
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month - 1, selectedDate.day);
      }
      widget.onDateChanged(selectedDate);
    });
  }

  void _selectNextMonth() {
    setState(() {
      if (selectedDate.month == 12) {
        selectedDate = DateTime(selectedDate.year + 1, 1, selectedDate.day);
      } else {
        selectedDate = DateTime(
            selectedDate.year, selectedDate.month + 1, selectedDate.day);
      }
      widget.onDateChanged(selectedDate);
    });
  }

  Future<void> _selectDateFromCalendar(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      locale: const Locale('pt', 'BR'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
            buttonTheme:
                const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked.toLocal();
        widget.onDateChanged(selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> meses = [
      'Jan',
      'Fev',
      'Mar',
      'Abr',
      'Mai',
      'Jun',
      'Jul',
      'Ago',
      'Set',
      'Out',
      'Nov',
      'Dez'
    ];

    String formattedDate = "${DateFormat('dd', 'pt_BR').format(selectedDate)}/"
        "${meses[selectedDate.month - 1]}/"
        "${DateFormat('yy', 'pt_BR').format(selectedDate)}";

    return Column(
      children: [
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios,
                  color: Colors.white, size: 24),
              onPressed: _selectPreviousDay,
            ),
            const SizedBox(width: 1),
            GestureDetector(
              onTap: () => _selectDateFromCalendar(context),
              child: Text(
                formattedDate,
                style: const TextStyle(fontSize: 22, color: Colors.white),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 2),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios,
                  color: Colors.white, size: 24),
              onPressed: _selectNextDay,
            ),
          ],
        ),
      ],
    );
  }
}
