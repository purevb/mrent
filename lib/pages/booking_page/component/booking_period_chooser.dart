import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mrent/model/property_table_calendar.dart';
import 'package:mrent/utils/constants.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingPeriodChooserComponent extends StatefulWidget {
  final Function(DateTime, DateTime) onDatesSelected;
  final bool forAddProperties;
  final List<PropertyTableCalendar> bookedDates;

  const BookingPeriodChooserComponent({
    super.key,
    required this.onDatesSelected,
    this.forAddProperties = false,
    this.bookedDates = const [],
  });

  @override
  State<BookingPeriodChooserComponent> createState() =>
      _BookingPeriodChooserComponentState();
}

class _BookingPeriodChooserComponentState
    extends State<BookingPeriodChooserComponent> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;
  final DateTime _firstDay = DateTime.now();
  final DateTime _lastDay = DateTime.now().add(const Duration(days: 365));

  Set<DateTime> _bookedDates = {};

  final List<String> _mongolianMonths = [
    '1-р сар',
    '2-р сар',
    '3-р сар',
    '4-р сар',
    '5-р сар',
    '6-р сар',
    '7-р сар',
    '8-р сар',
    '9-р сар',
    '10-р сар',
    '11-р сар',
    '12-р сар',
  ];

  final List<String> _mongolianWeekdays = [
    'Да',
    'Мя',
    'Лх',
    'Пү',
    'Ба',
    'Бя',
    'Ня'
  ];

  @override
  void initState() {
    super.initState();
    _processBookedDates();
  }

  @override
  void didUpdateWidget(BookingPeriodChooserComponent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bookedDates != widget.bookedDates) {
      _processBookedDates();
    }
  }

  void _processBookedDates() {
    _bookedDates = {};
    for (var booking in widget.bookedDates) {
      DateTime? start;
      DateTime? end;

      if (booking.start is DateTime) {
        start = booking.start as DateTime;
      } else if (booking.start is String) {
        try {
          start = DateTime.parse(booking.start as String);
        } catch (e) {
          log("Error parsing start date: $e");
        }
      }

      if (booking.end is DateTime) {
        end = booking.end as DateTime;
      } else if (booking.end is String) {
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
          _bookedDates.add(DateTime(date.year, date.month, date.day));
        }
      }
    }
  }

  bool _isDateBooked(DateTime day) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _bookedDates.contains(normalizedDay);
  }

  bool _isDateEnabled(DateTime day) {
    if (day.isBefore(_firstDay) ||
        day.isAfter(_lastDay) ||
        _isDateBooked(day)) {
      return false;
    }
    return true;
  }

  bool _isRangeValid(DateTime? start, DateTime? end) {
    if (start == null || end == null) return false;

    if (start.isAfter(end)) {
      return false;
    }

    for (var date = start;
        date.isBefore(end.add(const Duration(days: 1)));
        date = date.add(const Duration(days: 1))) {
      if (!_isDateEnabled(date)) {
        return false;
      }
    }
    return true;
  }

  // Widget calendar(
  //     BuildContext context,
  //     DateTime focusedDay,
  //     VoidCallback onLeftChevronTap,
  //     VoidCallback onRightChevronTap,
  //     VoidCallback onTodayTap,
  //     bool isTodayVisible) {
  //   final month = _mongolianMonths[focusedDay.month - 1];
  //   final year = focusedDay.year;

  //   return Container(
  //     margin: const EdgeInsets.symmetric(vertical: 4),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         IconButton(
  //           icon: const Icon(Icons.chevron_left),
  //           onPressed: onLeftChevronTap,
  //           color: mRed,
  //         ),
  //         GestureDetector(
  //           onTap: onTodayTap,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(20),
  //               // ignore: deprecated_member_use
  //               color: mRed.withOpacity(0.1),
  //             ),
  //             child: Text(
  //               '$month $year',
  //               style: GoogleFonts.inter(
  //                 color: mRed,
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 16,
  //               ),
  //             ),
  //           ),
  //         ),
  //         IconButton(
  //           icon: const Icon(Icons.chevron_right),
  //           onPressed: onRightChevronTap,
  //           color: mRed,
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      decoration: BoxDecoration(
        color: bookingColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TableCalendar(
            firstDay: _firstDay,
            lastDay: _lastDay,
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            headerStyle: HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
              leftChevronVisible: false,
              rightChevronVisible: false,
              titleTextStyle: GoogleFonts.inter(
                color: textDefaultColor,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              headerPadding: EdgeInsets.zero,
            ),
            calendarBuilders: CalendarBuilders(
              headerTitleBuilder: (context, day) {
                final month = _mongolianMonths[day.month - 1];
                final year = day.year;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Center(
                    child: Text(
                      '$month $year',
                      style: GoogleFonts.inter(
                        color: textDefaultColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                );
              },
              dowBuilder: (context, day) {
                return Center(
                  child: Text(
                    _mongolianWeekdays[day.weekday - 1],
                    style: GoogleFonts.inter(
                      color: day.weekday == 6 || day.weekday == 7
                          ? mRed
                          : textDefaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
              defaultBuilder: (context, day, focusedDay) {
                final isBooked = _isDateBooked(day);
                final isDisabled = !_isDateEnabled(day);
                final isToday = isSameDay(day, DateTime.now());
                final isSelected = isSameDay(_selectedDay, day);
                final isInRange = _rangeStart != null &&
                    _rangeEnd != null &&
                    (day.isAfter(_rangeStart!) && day.isBefore(_rangeEnd!) ||
                        isSameDay(day, _rangeStart) ||
                        isSameDay(day, _rangeEnd));

                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected
                        ? mRed
                        : isInRange
                            // ignore: deprecated_member_use
                            ? mRed.withOpacity(0.2)
                            : isToday
                                ? Colors.transparent
                                : Colors.transparent,
                    border:
                        isToday ? Border.all(color: mRed, width: 1.5) : null,
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: GoogleFonts.inter(
                        color: isSelected
                            ? Colors.white
                            : isDisabled
                                // ignore: deprecated_member_use
                                ? Colors.grey.withOpacity(0.5)
                                : isBooked
                                    ? Colors.grey
                                    : textDefaultColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
              disabledBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    // ignore: deprecated_member_use
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: Center(
                    child: Text(
                      day.day.toString(),
                      style: GoogleFonts.inter(
                        // ignore: deprecated_member_use
                        color: Colors.grey.withOpacity(0.5),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
              // ignore: deprecated_member_use
              rangeHighlightColor: mRed.withOpacity(0.1),
              withinRangeTextStyle: GoogleFonts.inter(
                color: textDefaultColor,
                fontWeight: FontWeight.w500,
              ),
              selectedTextStyle: GoogleFonts.inter(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              todayTextStyle: GoogleFonts.inter(
                color: mRed,
                fontWeight: FontWeight.w500,
              ),
              defaultTextStyle: GoogleFonts.inter(
                color: textDefaultColor,
                fontWeight: FontWeight.w500,
              ),
              selectedDecoration: BoxDecoration(
                color: mRed,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: mRed, width: 1.5),
                ),
              ),
              rangeStartDecoration: BoxDecoration(
                color: mRed,
                shape: BoxShape.circle,
              ),
              rangeEndDecoration: BoxDecoration(
                color: mRed,
                shape: BoxShape.circle,
              ),
              withinRangeDecoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              disabledTextStyle: GoogleFonts.inter(
                // ignore: deprecated_member_use
                color: Colors.grey.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
              holidayTextStyle: GoogleFonts.inter(
                color: mRed,
                fontWeight: FontWeight.w500,
              ),
              weekendTextStyle: GoogleFonts.inter(
                color: mRed,
                fontWeight: FontWeight.w500,
              ),
              cellMargin: const EdgeInsets.all(4),
            ),
            startingDayOfWeek: StartingDayOfWeek.monday,
            daysOfWeekHeight: 30,
            rowHeight: 42,
            rangeSelectionMode: RangeSelectionMode.toggledOn,
            availableCalendarFormats: const {
              CalendarFormat.month: 'Сар',
            },
            enabledDayPredicate: _isDateEnabled,
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _rangeStart = null;
                _rangeEnd = null;
                _focusedDay = focusedDay;
              });
            },
            onRangeSelected: (start, end, focusedDay) {
              setState(() {
                _selectedDay = null;
                _rangeStart = start;
                _rangeEnd = end;
                _focusedDay = focusedDay;

                if (start != null && end != null) {
                  if (_isRangeValid(start, end)) {
                    widget.onDatesSelected(start, end);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Сонгосон хугацаанд захиалга байна!'),
                        backgroundColor: Colors.grey,
                      ),
                    );
                    _rangeStart = null;
                    _rangeEnd = null;
                  }
                }
              });
            },
          ),
          const SizedBox(height: 10),
          if (_rangeStart != null && _rangeEnd != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: bookingColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Эхлэх огноо",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(_rangeStart!),
                        style: GoogleFonts.inter(
                          color: textDefaultColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Дуусах огноо",
                        style: GoogleFonts.inter(
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        DateFormat('yyyy-MM-dd').format(_rangeEnd!),
                        style: GoogleFonts.inter(
                          color: textDefaultColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
