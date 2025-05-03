import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.orderData,
  });
  final BookingModel orderData;
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Api api = Api();
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Захиалгын дэлгэрэнгүй"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 10,
          bottom: 30,
        ),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalProperty(
              propertyData: widget.orderData.propertyId!,
            ),
            Text(
              "Захиалагч",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            ListingAgent(
              user: widget.orderData.userId!,
            ),
            Text(
              "Өдөр",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${widget.orderData.checkinDate!.split("T")[0].replaceAll("-", ".")}-${widget.orderData.checkoutDate!.split("T")[0].split("T")[0].replaceAll("-", ".")}",
              style: GoogleFonts.inter(
                fontSize: 14,
              ),
            ),
            Text(
              "Нэмэлт тайлбар",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Text(
              widget.orderData.additionalRequest ?? "",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            Text(
              "Нийт төлбөр",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            Text(
              "₮${widget.orderData.totalPrice}",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            const Spacer(),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MyButton(
                    canPress: true,
                    onPress: () {
                      customDialog(context, forApprove: false);
                    },
                    height: 40,
                    width: 100,
                    text: "Цуцлах",
                    color: Colors.grey,
                    borderRadius: 10,
                  ),
                ),
                Expanded(
                  child: MyButton(
                    canPress: true,
                    onPress: () {
                      customDialog(
                        context,
                        forApprove: true,
                        provider: provider,
                      );
                    },
                    height: 40,
                    width: 100,
                    text: "Зөвшөөрөх",
                    borderRadius: 10,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> customDialog(
    BuildContext context, {
    PropertyProvider? provider,
    required bool forApprove,
  }) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            height: 400,
            margin: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Lottie.asset(
                  height: 150,
                  width: 150,
                  forApprove == true
                      ? 'assets/animation/approve.json'
                      : 'assets/animation/cancel.json',
                  fit: BoxFit.contain,
                ),
                Text(
                  textAlign: TextAlign.center,
                  forApprove == true
                      ? 'Та зөвшөөрөхдөө итгэлтэй байна уу ?'
                      : "Та цуцлахдаа итгэлтэй байна уу ?",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black
                                    // ignore: deprecated_member_use
                                    .withOpacity(0.2),
                                blurRadius: 1,
                              ),
                            ],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text("Үгүй"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          forApprove == true
                              ? await api
                                  .approveBookingRequest(
                                  orderId: widget.orderData.id ?? "",
                                  hostId: provider!.getUser!.id!,
                                  userId: widget.orderData.userId?.id ?? "",
                                )
                                  .then((_) async {
                                  await api
                                      .updateBookingStatus(
                                    bookingid: widget.orderData.id!,
                                    approved: true,
                                  )
                                      .then((_) async {
                                    await api.postEarning(
                                      bookingId: widget.orderData.id!,
                                      userId: provider.getUser?.id ?? "",
                                    );
                                    await api.postPayment(
                                      bookingId: widget.orderData.id!,
                                      userId: widget.orderData.userId?.id ?? "",
                                    );
                                  });
                                })
                              : await api.deleteBookingRequest(
                                  widget.orderData.id ?? "");
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context);
                          // ignore: use_build_context_synchronously
                          Navigator.pop(context, true);
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: mRed,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black
                                      // ignore: deprecated_member_use
                                      .withOpacity(0.2),
                                  blurRadius: 1),
                            ],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            "Тийм",
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
