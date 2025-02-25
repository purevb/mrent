import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class PaymentTypesComponent extends StatefulWidget {
  const PaymentTypesComponent({super.key});

  @override
  State<PaymentTypesComponent> createState() => _PaymentTypesComponentState();
}

class _PaymentTypesComponentState extends State<PaymentTypesComponent> {
  int selectedValue = -1;
  Map<int, Map<String, dynamic>> paymentDatas = {
    0: {
      "path": "assets/booking/payment_methods/mbank.png",
      "text": "Mbank",
      "index": 0,
    },
    1: {
      "path": "assets/booking/payment_methods/qpay.jpeg",
      "text": "Qpay",
      "index": 1,
    },
    2: {
      "path": "assets/booking/payment_methods/socialpay.png",
      "text": "Social pay",
      "index": 2,
    },
    3: {
      "path": "assets/booking/payment_methods/statebank.png",
      "text": "Төрийн банк",
      "index": 3,
    }
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 20,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Төлбөр төлөх сонголтууд",
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
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: paymentDatas.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 5),
                height: 45,
                child: paymentTile(
                  paymentDatas[index]!["path"],
                  paymentDatas[index]!["text"],
                  paymentDatas[index]!["index"],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Row paymentTile(String path, String text, int value) {
    return Row(
      spacing: 20,
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(30), child: Image.asset(path)),
        Text(text),
        const Spacer(),
        Radio(
          fillColor:
              WidgetStateProperty.resolveWith<Color>((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return mRed;
            }
            return Colors.black;
          }),
          value: value,
          groupValue: selectedValue,
          onChanged: (index) {
            setState(() {});
            selectedValue = index!;
          },
        ),
      ],
    );
  }
}
