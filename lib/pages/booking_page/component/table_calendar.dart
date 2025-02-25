import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class TableCalendarComponent extends StatefulWidget {
  final Function(DateTime)? onDateSelected;
  const TableCalendarComponent({this.onDateSelected, super.key});

  @override
  State<TableCalendarComponent> createState() => _TableCalendarComponentState();
}

class _TableCalendarComponentState extends State<TableCalendarComponent> {
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  @override
  void initState() {
    widget.onDateSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Dialog(
      backgroundColor: backgroundColor,
      child: Container(
        height: height * 0.5,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(40)),
        child: TableCalendar(
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
            if (widget.onDateSelected != null) {
              setState(() {
                widget.onDateSelected!(selectedDay);
              });
            }
          },
          selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: mRed,
              shape: BoxShape.circle,
            ),
            todayDecoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
        ),
      ),
    );
  }
}
