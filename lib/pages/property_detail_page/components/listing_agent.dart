import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/utils/constants.dart';

class ListingAgent extends StatefulWidget {
  const ListingAgent({super.key});

  @override
  State<ListingAgent> createState() => _ListingAgentState();
}

class _ListingAgentState extends State<ListingAgent> {
  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.black,
          ),
          // child: CachedNetworkImage(
          //   imageUrl: "",
          //   errorWidget: (context, url, error) {
          //     return const Center(
          //       child: CircularProgressIndicator(
          //         color: Colors.red,
          //       ),
          //     );
          //   },
          // ),
        ),
        Text(
          "Sandeep S.",
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            // ignore: deprecated_member_use
            color: textDefaultColor.withOpacity(0.7),
          ),
        ),
        const Spacer(),
        SvgPicture.asset(
          "assets/property_detail/eva_email-fill.svg",
          colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              textDefaultColor.withOpacity(0.7),
              BlendMode.srcIn),
        ),
        SvgPicture.asset(
          "assets/property_detail/mingcute_phone-fill.svg",
          colorFilter: ColorFilter.mode(
              // ignore: deprecated_member_use
              textDefaultColor.withOpacity(0.7),
              BlendMode.srcIn),
        ),
      ],
    );
  }
}
