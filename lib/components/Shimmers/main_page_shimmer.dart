import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/utils/constants.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShimmerLoadingWidget extends StatelessWidget {
  const ShimmerLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Container(
      color: backgroundColor,
      padding: const EdgeInsets.only(top: 20),
      child: ListView(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  margin: const EdgeInsets.only(left: 30, right: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: backgroundColor,
                    boxShadow: [
                      BoxShadow(
                        // ignore: deprecated_member_use
                        color: textDefaultColor.withOpacity(0.15),
                        blurRadius: 2,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  height: height * 0.07,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: width * 0.8 - 60,
                        child: Row(
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: SvgPicture.asset(
                                "assets/search/searchbutton.svg",
                                fit: BoxFit.fitHeight,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Хайлт",
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Shimmer.fromColors(
            period: const Duration(milliseconds: 1800),
            // ignore: deprecated_member_use
            baseColor: Colors.grey.withOpacity(0.1),
            highlightColor: Colors.white,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: ListView.separated(
                    padding: const EdgeInsets.only(left: 30, top: 10),
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (_, __) => Row(
                      children: [
                        Container(
                          height: 30,
                          width: 30,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    separatorBuilder: (_, __) => const SizedBox(width: 10),
                  ),
                ),
                const Divider(
                  thickness: 3,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(20),
                  itemCount: 5,
                  itemBuilder: (_, __) => Container(
                    height: height * 0.45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          height: 30,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
