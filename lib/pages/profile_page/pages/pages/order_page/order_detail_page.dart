import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/profile_page/pages/pages/order_page/orders_page.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    super.key,
    required this.orderData,
  });
  final OrderModel orderData;
  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  @override
  Widget build(BuildContext context) {
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
                    onPress: () {},
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
                    onPress: () {},
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
}
