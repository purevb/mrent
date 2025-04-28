import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mrent/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class SimpleDatePicker extends StatefulWidget {
  const SimpleDatePicker({
    super.key,
    required this.onSelectDateRange,
    this.rangeStart,
    this.rangeEnd,
  });

  final void Function(DateTime, DateTime) onSelectDateRange;
  final DateTime? rangeStart, rangeEnd;

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  DateTime? _selectedDay;
  late DateTime? _rangeStart;
  late DateTime _focusedDay;
  late DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();
    _rangeStart = widget.rangeStart ?? DateTime.now();
    _focusedDay = DateTime.now();
    _rangeEnd = widget.rangeEnd ?? DateTime.now();

    initializeDateFormatting('mn', null);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    const textDarkColor = Colors.black87;
    const textMediumColor = Colors.black54;

    return Card(
      color: Colors.white,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TableCalendar(
                availableCalendarFormats: const {
                  CalendarFormat.month: 'Month',
                },
                focusedDay: _focusedDay,
                firstDay: DateTime(2020),
                lastDay: DateTime(2030),
                rangeStartDay: _rangeStart,
                rangeEndDay: _rangeEnd,
                rangeSelectionMode: RangeSelectionMode.enforced,
                locale: 'mn',
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onRangeSelected: (start, end, focusedDay) {
                  setState(() {
                    _selectedDay = null;
                    _focusedDay = focusedDay;
                    _rangeStart = start;
                    _rangeEnd = end;
                  });
                },
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                calendarStyle: CalendarStyle(
                  defaultTextStyle: const TextStyle(
                    color: textDarkColor,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendTextStyle: const TextStyle(
                    color: textMediumColor,
                  ),
                  rangeStartDecoration: BoxDecoration(
                    color: mRed,
                    shape: BoxShape.circle,
                  ),
                  rangeEndDecoration: BoxDecoration(
                    color: mRed,
                    shape: BoxShape.circle,
                  ),
                  // ignore: deprecated_member_use
                  rangeHighlightColor: mRed.withOpacity(0.2),
                  todayDecoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: textMediumColor,
                  ),
                  rangeStartTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  rangeEndTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: textDarkColor,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
