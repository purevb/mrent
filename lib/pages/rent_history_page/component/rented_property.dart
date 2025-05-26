import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:mrent/model/order_model.dart';
import 'package:mrent/pages/rent_history_page/component/rating_component.dart';
import 'package:mrent/utils/constants.dart';

class RentedProperty extends StatefulWidget {
  const RentedProperty({
    required this.bookingdata,
    super.key,
  });
  final BookingModel bookingdata;

  @override
  State<RentedProperty> createState() => _RentedPropertyState();
}

class _RentedPropertyState extends State<RentedProperty> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Container(
      margin: const EdgeInsets.only(right: 20),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      height: 280,
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
              images: widget.bookingdata.propertyId?.images ?? [],
            ),
          ),
          Expanded(
            child: Column(
              spacing: 10,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  maxLines: 2,
                  widget.bookingdata.propertyId?.propertyName.toString() ?? "",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  widget.bookingdata.propertyId?.description.toString() ?? "",
                  maxLines: 2,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  "Эхлэсэн өдөр:${widget.bookingdata.checkinDate!.split("T")[0].replaceAll("-", "/")}",
                ),
                Text(
                  "Дууссан өдөр:${widget.bookingdata.checkoutDate!.split("T")[0].replaceAll("-", "/")}",
                ),
                //-
                GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return RatingComponent(
                          propertyId: widget.bookingdata.propertyId?.id ?? "",
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // ignore: deprecated_member_use
                        color: mRed.withOpacity(0.3),
                        border: Border.all(color: mRed)),
                    child: const Text(
                      "Үнэлгээ өгөх",
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    "${formatPoint(widget.bookingdata.totalPrice ?? 0)}₮",
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
