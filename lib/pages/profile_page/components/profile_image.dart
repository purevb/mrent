import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class ProfileImage extends StatelessWidget {
  const ProfileImage({
    required this.proImage,
    super.key,
  });
  final String proImage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 90,
          width: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CachedNetworkImage(
              imageUrl: proImage,
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textDefaultColor,
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                CupertinoIcons.pencil_circle,
                size: 20,
              ),
              color: Colors.white,
              padding: EdgeInsets.zero,
              constraints: BoxConstraints(),
            ),
          ),
        )
      ],
    );
  }
}
