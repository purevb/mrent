import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/utils/constants.dart';

class ListingAgent extends StatefulWidget {
  const ListingAgent({required this.user, super.key});
  final MongoUserModel user;

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
          child: ClipOval(
            child: CachedNetworkImage(
              fit: BoxFit.fill,
              imageUrl: widget.user.profileImage ??
                  "https://cdn-icons-png.flaticon.com/128/1999/1999625.png",
              errorWidget: (context, url, error) {
                return Center(
                  child: CircularProgressIndicator(
                    color: mRed,
                  ),
                );
              },
            ),
          ),
        ),
        Text(
          widget.user.name ?? "",
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
