import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/pages/booking_page/component/table_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:mrent/utils/constants.dart';

class BookingPeriodChooserComponent extends StatefulWidget {
  const BookingPeriodChooserComponent(
      {super.key, required this.onDatesSelected});
  final Function(DateTime?, DateTime?) onDatesSelected;

  @override
  State<BookingPeriodChooserComponent> createState() =>
      _BookingPeriodChooserComponentState();
}

class _BookingPeriodChooserComponentState
    extends State<BookingPeriodChooserComponent> {
  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;
  String formatDate(DateTime? time) {
    return time != null ? DateFormat('yyyy-MM-dd').format(time) : "Сонгох";
  }

  void updateSelectedDates() {
    widget.onDatesSelected(_firstSelectedDay, _secondSelectedDay);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Хугацаа сонгох",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Row(
          spacing: 10,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TableCalendarComponent(
                        onDateSelected: (selectedDate) {
                          setState(() {
                            _firstSelectedDay = selectedDate;
                          });
                          updateSelectedDates();
                        },
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 65,
                  decoration: BoxDecoration(
                    color: bookingColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      SvgPicture.asset(width: 20, "assets/booking/date.svg"),
                      Text(
                        _firstSelectedDay != null
                            ? formatDate(_firstSelectedDay)
                            : "Ирэх",
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: textDefaultColor.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return TableCalendarComponent(
                        onDateSelected: (selectedDate) {
                          setState(() {
                            _secondSelectedDay = selectedDate;
                          });
                          updateSelectedDates();
                        },
                      );
                    },
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  height: 65,
                  decoration: BoxDecoration(
                    color: bookingColor,
                    borderRadius: BorderRadius.circular(
                      20,
                    ),
                  ),
                  child: Row(
                    spacing: 10,
                    children: [
                      SvgPicture.asset(width: 20, "assets/booking/date.svg"),
                      Text(
                        _secondSelectedDay != null
                            ? formatDate(_secondSelectedDay)
                            : "Гарах",
                        style: TextStyle(
                          // ignore: deprecated_member_use
                          color: textDefaultColor.withOpacity(
                            0.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
