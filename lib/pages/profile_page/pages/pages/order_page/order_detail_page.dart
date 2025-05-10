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
  bool _isProcessing = false;

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
        ),
        child: ListView(
          children: [
            HorizontalProperty(
              propertyData: widget.orderData.propertyId!,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Захиалагч",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ListingAgent(
              user: widget.orderData.userId!,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Өдөр",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${widget.orderData.checkinDate!.split("T")[0].replaceAll("-", ".")}-${widget.orderData.checkoutDate!.split("T")[0].split("T")[0].replaceAll("-", ".")}",
              style: GoogleFonts.inter(
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Нэмэлт тайлбар",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              widget.orderData.additionalRequest ?? "",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Нийт төлбөр",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "₮${widget.orderData.totalPrice}",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 18,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: MyButton(
                    canPress: !_isProcessing,
                    onPress: () {
                      if (!_isProcessing) {
                        customDialog(context, forApprove: false);
                      }
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
                    canPress: !_isProcessing,
                    onPress: () {
                      if (!_isProcessing) {
                        customDialog(
                          context,
                          forApprove: true,
                          provider: provider,
                        );
                      }
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
        bool isDialogProcessing = false;

        return StatefulBuilder(builder: (context, setDialogState) {
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
                          onTap: isDialogProcessing
                              ? null
                              : () {
                                  Navigator.pop(context);
                                },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDialogProcessing
                                  ? Colors.grey.shade300
                                  : Colors.grey,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
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
                          onTap: isDialogProcessing
                              ? null
                              : () async {
                                  if (isDialogProcessing) return;

                                  setDialogState(() {
                                    isDialogProcessing = true;
                                  });

                                  setState(() {
                                    _isProcessing = true;
                                  });

                                  try {
                                    if (forApprove == true) {
                                      await api.approveBookingRequest(
                                        orderId: widget.orderData.id ?? "",
                                        hostId: provider!.getUser!.id!,
                                        userId:
                                            widget.orderData.userId?.id ?? "",
                                      );

                                      await api.updateBookingStatus(
                                        bookingid: widget.orderData.id!,
                                        approved: true,
                                      );

                                      await api.postEarning(
                                        bookingId: widget.orderData.id!,
                                        userId: provider.getUser?.id ?? "",
                                      );

                                      await api.postPayment(
                                        bookingId: widget.orderData.id!,
                                        userId:
                                            widget.orderData.userId?.id ?? "",
                                      );
                                    } else {
                                      await api.deleteBookingRequest(
                                          bookingId: widget.orderData.id ?? "");
                                    }

                                    if (mounted) {
                                      Navigator.pop(context);
                                      Navigator.pop(context, true);
                                    }
                                  } catch (e) {
                                    debugPrint("Error processing request: $e");
                                    if (mounted) {
                                      setDialogState(() {
                                        isDialogProcessing = false;
                                      });

                                      setState(() {
                                        _isProcessing = false;
                                      });

                                      // Show error message to user
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text("Error: $e"),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                },
                          child: Container(
                            height: 40,
                            decoration: BoxDecoration(
                              color: isDialogProcessing
                                  ? Colors.grey.shade300
                                  : mRed,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 1,
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                            ),
                            alignment: Alignment.center,
                            child: isDialogProcessing
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : const Text(
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
        });
      },
    );
  }
}
