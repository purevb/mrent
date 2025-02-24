import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
        const Text(
          "Sandeep S.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        SvgPicture.asset(
          "assets/property_detail/eva_email-fill.svg",
          colorFilter: ColorFilter.mode(mRed, BlendMode.srcIn),
        ),
        SvgPicture.asset(
          "assets/property_detail/mingcute_phone-fill.svg",
          colorFilter: ColorFilter.mode(mRed, BlendMode.srcIn),
        ),
      ],
    );
  }
}
