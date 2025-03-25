import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';

class CarouselSlider extends StatelessWidget {
  const CarouselSlider(
      {super.key,
      required this.width,
      required this.height,
      this.images,
      this.provider});
  final double width;
  final double height;

  final List<String>? images;
  final PropertyProvider? provider;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.2,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AspectRatio(
          aspectRatio: 2 / 1,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Swiper(
                pagination: SwiperPagination(
                  builder: DotSwiperPaginationBuilder(
                    activeSize: 5,
                    size: 5,
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.5),
                    activeColor: Colors.white,
                  ),
                ),
                itemCount: images?.length ?? 0,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: images?[index] ?? "",
                  );
                },
              ),
              Positioned(
                top: 8,
                left: 8,
                child: SizedBox(
                  width: width - 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white, width: 1),
                          // ignore: deprecated_member_use
                          color: Colors.white.withOpacity(0.7),
                        ),
                        child: Center(
                          child: Text(
                            "Олонд таалагдсан",
                            style: GoogleFonts.inter(
                              color: textDefaultColor,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
