import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:mrent/model/order_model.dart';

class RentedProperty extends StatelessWidget {
  const RentedProperty({
    required this.bookingdata,
    super.key,
  });
  final BookingModel bookingdata;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 250,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
            spreadRadius: 0.5,
          ),
        ],
        borderRadius: BorderRadius.circular(
          25,
        ),
      ),
      child: Row(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            width: width * 0.5,
            child: CarouselSlider(
              height: height,
              width: width * 0.5,
              images: bookingdata.propertyId?.images ?? [],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  bookingdata.propertyId?.propertyName.toString() ?? "",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  bookingdata.propertyId?.description.toString() ?? "",
                  maxLines: 4,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Эхлэсэн өдөр:${bookingdata.checkinDate!.split("T")[0].replaceAll("-", "/")}",
                ),
                Text(
                  "Дууссан өдөр:${bookingdata.checkoutDate!.split("T")[0].replaceAll("-", "/")}",
                ),
                //-
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "₮${bookingdata.propertyId?.nightlyPrice.toString()}",
                    style: GoogleFonts.inter(
                      fontSize: 19,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
