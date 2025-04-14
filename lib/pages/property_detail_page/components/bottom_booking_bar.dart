import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/pages/booking_page/booking_page.dart';
import 'package:mrent/pages/login_dropback/login.dart';

class BottomBookingBar extends StatelessWidget {
  const BottomBookingBar({
    super.key,
    this.user,
    required this.width,
    required this.propertyData,
  });
  final PropertyModel propertyData;
  final FbUserModel? user;

  final double width;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
        width: width,
        height: 90,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              // ignore: deprecated_member_use
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 1,
              offset: const Offset(
                0,
                -1,
              ),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Нийт үнэ",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(fontSize: 10, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '₮',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: propertyData.nightlyPrice.toString(),
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: '/',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                      TextSpan(
                        text: 'өдөрт',
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10),
              child: MyButton(
                borderRadius: 16,
                canPress: true,
                onPress: () {
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return BookingPage(
                            user: user!,
                            propertyData: propertyData,
                          );
                        },
                      ),
                    );
                  } else {
                    showModalBottomSheet(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return const Login();
                      },
                    );
                  }
                },
                height: 60,
                width: 150,
                text: "Захиалах",
              ),
            )
          ],
        ),
      ),
    );
  }
}
