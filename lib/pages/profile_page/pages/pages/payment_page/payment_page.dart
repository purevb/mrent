import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key, required this.user});
  final MongoUserModel user;

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  DataController dataController = DataController();
  @override
  void initState() {
    dataController.getEarningDateData(widget.user.id!);
    dataController.getPaymentData(widget.user.id!);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Төлбөр"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(),
      ),
    );
  }
}
