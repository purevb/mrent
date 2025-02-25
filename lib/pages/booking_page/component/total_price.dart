import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class TotalPriceComponent extends StatefulWidget {
  const TotalPriceComponent({super.key, this.totalDays});
  final int? totalDays;

  @override
  State<TotalPriceComponent> createState() => _TotalPriceComponentState();
}

class _TotalPriceComponentState extends State<TotalPriceComponent> {
  int perDayCost = 10000;
  int perDayServiceCost = 10000;
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Нийт төлбөр",
          style: TextStyle(
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
              buildRow("Өдрийн төлбөр", perDayCost),
              buildDays(widget.totalDays ?? 0),
              buildRow("Үйлчилгээний төлбөр", perDayServiceCost),
              const Divider(),
              buildRow("Нийт төлбөр",
                  perDayCost * widget.totalDays! + perDayServiceCost),
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
