import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/components/carousel_slider.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/model/fb_user_model.dart';
import 'package:mrent/pages/login_dropback/login.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:provider/provider.dart';

class FavoriteProperty extends StatefulWidget {
  const FavoriteProperty({
    required this.propertyData,
    super.key,
  });
  final PropertyModel propertyData;

  @override
  State<FavoriteProperty> createState() => _FavoritePropertyState();
}

class _FavoritePropertyState extends State<FavoriteProperty> {
  Api api = Api();
  bool favorite = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: height * 0.4,
      width: width * 0.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            blurRadius: 1,
            spreadRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Expanded(
            flex: 2,
            child: CarouselSlider(
              height: height,
              width: width,
              images: widget.propertyData.images,
              provider: provider,
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, left: 5, right: 5),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          maxLines: 1,
                          widget.propertyData.propertyName ?? "",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (provider.getUser != null) {
                            setState(() {});
                            provider.toggleFavorite(widget.propertyData);
                            if (provider.isExist(widget.propertyData) == true) {
                              api.postFavorites(
                                widget.propertyData.id!,
                                provider.getUser!.id,
                              );
                            } else {
                              api.postFavorites(
                                widget.propertyData.id!,
                                provider.getUser!.id,
                              );
                            }
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
                        child: SizedBox(
                          height: 20,
                          width: 25,
                          child: SvgPicture.asset(
                            fit: BoxFit.fitHeight,
                            provider.isExist(widget.propertyData) == true
                                ? "assets/object/pressedlike.svg"
                                : "assets/object/Vector.svg",
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    widget.propertyData.description ?? "",
                    maxLines: 3,
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    spacing: 5,
                    children: [
                      const Icon(
                        CupertinoIcons.bed_double,
                        size: 15,
                      ),
                      Text(
                        "${widget.propertyData.numBeds.toString()}.0",
                      ),
                      const Icon(
                        CupertinoIcons.person_2,
                        size: 15,
                      ),
                      Text(
                        "${widget.propertyData.numGuests.toString()}.0",
                      ),
                    ],
                  ),
                  const Spacer(),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.inter(
                            fontSize: 10, color: Colors.black),
                        children: [
                          TextSpan(
                            text: '₮',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: widget.propertyData.nightlyPrice.toString(),
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          TextSpan(
                            text: '/',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextSpan(
                            text: 'өдөр',
                            style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
