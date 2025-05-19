import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mrent/model/order_model.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:mrent/model/property_table_calendar.dart';
import 'package:mrent/utils/constants.dart';

class ImprovedMongolianCalendar extends StatefulWidget {
  final List<PropertyTableCalendar> bookedDates;
  final Function(DateTime, DateTime) onDatesSelected;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final String? currentBookingId;

  const ImprovedMongolianCalendar({
    super.key,
    required this.bookedDates,
    required this.onDatesSelected,
    this.initialStartDate,
    this.initialEndDate,
    this.currentBookingId,
  });

  @override
  State<ImprovedMongolianCalendar> createState() =>
      _ImprovedMongolianCalendarState();
}

class _ImprovedMongolianCalendarState extends State<ImprovedMongolianCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late DateTime _focusedDay;
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;

  Map<DateTime, bool> _bookedDatesCache = {};

  final List<String> _mongolianMonthNames = [
    'Нэгдүгээр сар',
    'Хоёрдугаар сар',
    'Гуравдугаар сар',
    'Дөрөвдүгээр сар',
    'Тавдугаар сар',
    'Зургадугаар сар',
    'Долдугаар сар',
    'Наймдугаар сар',
    'Есдүгээр сар',
    'Аравдугаар сар',
    'Арван нэгдүгээр сар',
    'Арван хоёрдугаар сар',
  ];

  final List<String> _mongolianDayNames = [
    'Да',
    'Мя',
    'Лх',
    'Пү',
    'Ба',
    'Бя',
    'Ня',
  ];

  @override
  void initState() {
    super.initState();

    if (widget.initialStartDate != null && widget.initialEndDate != null) {
      _rangeStart = widget.initialStartDate;
      _rangeEnd = widget.initialEndDate;
      _focusedDay = _rangeStart!;

      widget.onDatesSelected(_rangeStart!, _rangeEnd!);
    } else {
      _focusedDay = DateTime.now();
    }

    _processBookedDates();
  }

  @override
  void didUpdateWidget(ImprovedMongolianCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.bookedDates != widget.bookedDates) {
      _processBookedDates();
    }

    if (widget.initialStartDate != oldWidget.initialStartDate ||
        widget.initialEndDate != oldWidget.initialEndDate) {
      if (widget.initialStartDate != null && widget.initialEndDate != null) {
        setState(() {
          _rangeStart = widget.initialStartDate;
          _rangeEnd = widget.initialEndDate;
          _focusedDay = _rangeStart!;
        });
      }
    }
  }

  void _processBookedDates() {
    _bookedDatesCache = {};

    for (var booking in widget.bookedDates) {
      if (widget.currentBookingId != null &&
          booking.id == widget.currentBookingId) {
        continue;
      }

      DateTime? start;
      DateTime? end;

      if (booking.start is String) {
        try {
          start = DateTime.parse(booking.start as String);
        } catch (e) {
          log("Error parsing start date: $e");
        }
      }

      if (booking.end is String) {
        try {
          end = DateTime.parse(booking.end as String);
        } catch (e) {
          log("Error parsing end date: $e");
        }
      }

      if (start != null && end != null) {
        for (var date = start;
            date.isBefore(end.add(const Duration(days: 1)));
            date = date.add(const Duration(days: 1))) {
          final normalizedDate = DateTime(date.year, date.month, date.day);
          _bookedDatesCache[normalizedDate] = true;
        }
      }
    }
  }

  bool _isDateBooked(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _bookedDatesCache[normalizedDay] == true;
  }

  bool _isDateEnabled(DateTime day) {
    if (day.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      return false;
    }

    if (_isDateBooked(day)) {
      return false;
    }

    return true;
  }

  bool _isRangeValid(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;

    if (start.isAfter(end)) {
      DateTime temp = start;
      start = end;
      end = temp;
    }

    for (var date = start;
        date.isBefore(end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      if (!_isDateEnabled(date) &&
          !isSameDay(date, start) &&
          !isSameDay(date, end)) {
        return false;
      }
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.now().subtract(const Duration(days: 1)),
          lastDay: DateTime.now().add(const Duration(days: 365)),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          headerStyle: HeaderStyle(
            titleCentered: true,
            formatButtonVisible: false,
            titleTextFormatter: (date, locale) {
              return '${_mongolianMonthNames[date.month - 1]} ${date.year}';
            },
            titleTextStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          daysOfWeekHeight: 30,
          daysOfWeekStyle: DaysOfWeekStyle(
            weekdayStyle: GoogleFonts.inter(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
            weekendStyle: GoogleFonts.inter(
              color: mRed,
              fontWeight: FontWeight.w500,
            ),
            dowTextFormatter: (date, locale) {
              return _mongolianDayNames[date.weekday - 1];
            },
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          rangeStartDay: _rangeStart,
          rangeEndDay: _rangeEnd,
          calendarStyle: CalendarStyle(
            isTodayHighlighted: true,
            todayDecoration: BoxDecoration(
              color: Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: mRed, width: 1),
            ),
            todayTextStyle: GoogleFonts.inter(
              color: mRed,
              fontWeight: FontWeight.bold,
            ),
            selectedDecoration: BoxDecoration(
              color: mRed,
              shape: BoxShape.circle,
            ),
            rangeStartDecoration: BoxDecoration(
              color: mRed,
              shape: BoxShape.circle,
            ),
            rangeEndDecoration: BoxDecoration(
              color: mRed,
              shape: BoxShape.circle,
            ),
            rangeHighlightColor: mRed.withOpacity(0.1),
            outsideDaysVisible: false,
            weekendTextStyle: GoogleFonts.inter(color: mRed),
            disabledTextStyle: GoogleFonts.inter(color: Colors.grey),
            markersMaxCount: 1,
            markerDecoration: const BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
            ),
          ),
          enabledDayPredicate: _isDateEnabled,
          rangeSelectionMode: _rangeSelectionMode,
          onDaySelected: (selectedDay, focusedDay) {
            if (!isSameDay(_selectedDay, selectedDay)) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;

                if (_rangeStart == null) {
                  _rangeStart = selectedDay;
                } else if (_rangeEnd == null) {
                  if (selectedDay.isBefore(_rangeStart!)) {
                    _rangeEnd = _rangeStart;
                    _rangeStart = selectedDay;
                  } else {
                    _rangeEnd = selectedDay;
                  }

                  if (_isRangeValid(_rangeStart, _rangeEnd)) {
                    widget.onDatesSelected(_rangeStart!, _rangeEnd!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                            'Энэ хугацаа бол боломжгүй. Өөр хугацаа сонгоно уу.'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                    _rangeStart = null;
                    _rangeEnd = null;
                  }
                } else {
                  _rangeStart = selectedDay;
                  _rangeEnd = null;
                }
              });
            }
          },
          onRangeSelected: (start, end, focusedDay) {
            setState(() {
              _selectedDay = null;
              _focusedDay = focusedDay;
              _rangeStart = start;
              _rangeEnd = end;

              if (start != null && end != null) {
                if (_isRangeValid(start, end)) {
                  widget.onDatesSelected(start, end);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Энэ хугацаа бол боломжгүй. Өөр хугацаа сонгоно уу.',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      backgroundColor: mRed,
                    ),
                  );
                  _rangeStart = null;
                  _rangeEnd = null;
                }
              }
            });
          },
          onPageChanged: (focusedDay) {
            setState(() {
              _focusedDay = focusedDay;
            });
          },
          calendarBuilders: CalendarBuilders(
            markerBuilder: (context, date, events) {
              if (_isDateBooked(date)) {
                return Positioned(
                  bottom: 1,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                  ),
                );
              }
              return null;
            },
          ),
        ),
        const SizedBox(height: 20),
        if (_rangeStart != null && _rangeEnd != null)
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: mRed,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ирэх',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      DateFormat('yyyy оны MM сарын dd').format(_rangeStart!),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(Icons.arrow_forward, color: Colors.grey),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Явах',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      DateFormat('yyyy оны MM сарын dd').format(_rangeEnd!),
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
