import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/utils/constants.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({
    super.key,
    required this.user,
  });
  final MongoUserModel user;
  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final DataController dataController = DataController();
  @override
  void initState() {
    dataController.getPaymentData(widget.user.id!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Төлөлт",
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: ValueListenableBuilder(
            valueListenable: dataController.paymentDataNotifier,
            builder: (context, paymentData, child) {
              if (paymentData == null) {
                return SizedBox(
                  height: height,
                  child: CircularProgressIndicator(
                    color: mRed,
                  ),
                );
              }
              if (paymentData.isEmpty) {
                log("sda");
                return SizedBox(
                  height: height,
                  child: const Center(
                    child: Text(
                      "Та одоогоор ямар нэгэн сууц түрээслээгүй байна.",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: paymentData.length,
                      itemBuilder: (context, int index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 30,
                                backgroundImage: CachedNetworkImageProvider(
                                  paymentData[index]
                                          .bookingId
                                          ?.userId
                                          ?.profileImage ??
                                      "https://cdn-icons-png.flaticon.com/128/4140/4140048.png",
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ],
              );
            }),
      ),
    );
  }
}
