import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Төлбөр"),
      ),
    );
  }
}
