import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/utils/constants.dart';

class TotalPriceComponent extends StatefulWidget {
  const TotalPriceComponent({
    super.key,
    this.totalDays,
    required this.nightlyPrice,
    required this.perDayServiceCost,
  });
  final int? totalDays;
  final int nightlyPrice;
  final int perDayServiceCost;

  @override
  State<TotalPriceComponent> createState() => _TotalPriceComponentState();
}

class _TotalPriceComponentState extends State<TotalPriceComponent> {
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Нийт төлбөр",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          decoration: BoxDecoration(
            color: bookingColor,
            borderRadius: BorderRadius.circular(
              20,
            ),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,
            children: [
              buildRow("Өдрийн төлбөр", widget.nightlyPrice),
              buildDays(widget.totalDays ?? 0),
              buildRow("Үйлчилгээний төлбөр", widget.perDayServiceCost),
              const Divider(),
              buildRow(
                  "Нийт төлбөр",
                  widget.nightlyPrice * widget.totalDays! +
                      widget.perDayServiceCost),
            ],
          ),
        ),
      ],
    );
  }

  Padding buildDays(int days) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          const Text("Нийт өдрүүд"),
          const Spacer(),
          Text("$days өдөр"),
        ],
      ),
    );
  }

  Padding buildRow(String text, int price) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6.0),
      child: Row(
        children: [
          Text(text),
          const Spacer(),
          Text(
            "${price.toString()}₮",
          ),
        ],
      ),
    );
  }
}
