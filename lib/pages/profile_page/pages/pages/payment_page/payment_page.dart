import 'package:auto_route/annotations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/utils/constants.dart';

@RoutePage()
class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Төлбөр"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {
            return Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: Row(
                    spacing: 8,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 65,
                        width: 65,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            100,
                          ),
                          child: CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl:
                                "https://cdn-icons-png.flaticon.com/128/4140/4140047.png",
                            errorWidget: (context, url, error) =>
                                const SizedBox(),
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Purevbaatar Ganbat,",
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "2025.01.23 14:05",
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: textColor,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                        child: Text(
                          "-40000₮",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  // ignore: deprecated_member_use
                  color: Colors.grey.withOpacity(0.3),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return const SizedBox(
              height: 12,
            );
          },
          itemCount: 10,
        ),
      ),
    );
  }
}
