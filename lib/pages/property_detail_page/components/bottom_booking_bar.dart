import 'package:flutter/material.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';

class BottomBookingBar extends StatelessWidget {
  const BottomBookingBar({
    super.key,
    required this.width,
  });

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
                const Text(
                  "Total price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(fontSize: 10, color: Colors.black),
                    children: [
                      TextSpan(
                        text: '\$',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                      TextSpan(
                        text: '350',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                      TextSpan(
                        text: '/',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                        ),
                      ),
                      TextSpan(
                        text: 'month',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MapSample(),
                    ),
                  );
                },
                height: 60,
                width: 150,
                text: "Book now",
              ),
            )
          ],
        ),
      ),
    );
  }
}
