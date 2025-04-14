import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/pages/booking_page/component/table_calendar.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import 'package:mrent/utils/constants.dart';

class BookingPeriodChooserComponent extends StatefulWidget {
  const BookingPeriodChooserComponent({
    super.key,
    required this.forAddProperties,
    required this.onDatesSelected,
  });
  final Function(DateTime?, DateTime?) onDatesSelected;
  final bool forAddProperties;
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
        Text(
          "Хугацаа сонгох",
          style: GoogleFonts.inter(
            fontSize: widget.forAddProperties == true ? 16 : 18,
            fontWeight: widget.forAddProperties == true
                ? FontWeight.bold
                : FontWeight.w500,
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
                    // color: bookingColor,
                    color: widget.forAddProperties == true
                        ? const Color.fromARGB(255, 227, 226, 230)
                        : bookingColor,

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
                        style: GoogleFonts.inter(
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
                    // color: bookingColor,
                    color: widget.forAddProperties == true
                        ? const Color.fromARGB(255, 227, 226, 230)
                        : bookingColor,
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
                        style: GoogleFonts.inter(
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
