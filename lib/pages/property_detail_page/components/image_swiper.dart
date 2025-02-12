import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';

class ImageSwiper extends StatelessWidget {
  const ImageSwiper({
    super.key,
    required this.height,
    required this.images,
  });

  final double height;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.4,
      child: Swiper(
        itemCount: images.length,
        pagination: SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeSize: 5,
            size: 5,
            color: Colors.white.withOpacity(0.5),
            activeColor: Colors.white,
          ),
        ),
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: images[index],
            errorWidget: (context, url, error) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
