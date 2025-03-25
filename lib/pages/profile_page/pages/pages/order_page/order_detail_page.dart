import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/horizontal_property.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/listing_agent.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          spacing: 10,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HorizontalProperty(
              propertyData: widget.propertyData,
            ),
            Text(
              "Захиалагч",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const ListingAgent(),
            Text(
              "Өдөр",
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "2025.6.25-2025.06.27",
              style: GoogleFonts.inter(
                fontSize: 16,
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
              "Нэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбарНэмэлт тайлбар",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w400,
                fontSize: 16,
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
              "\$120",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
