import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mrent/utils/constants.dart';

class NotesForOwnerComponent extends StatelessWidget {
  const NotesForOwnerComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 20,
      children: [
        const Text(
          "Түрээслэгчид ",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          height: 65,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bookingColor,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: Row(
            spacing: 10,
            children: [
              SvgPicture.asset(width: 20, "assets/booking/Messaging.svg"),
              Text(
                "Нэмэлт хүсэлт илгээх",
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
      ],
    );
  }
}
