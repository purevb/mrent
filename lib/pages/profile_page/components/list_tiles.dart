import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileListTiles extends StatelessWidget {
  const ProfileListTiles({
    required this.iconPath,
    required this.description,
    required this.onPressed,
    super.key,
  });
  final String iconPath;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    // double width = MediaQuery.of(context).size.width;

    return Row(
      spacing: 15,
      children: [
        SizedBox(
          height: height * 0.03,
          width: height * 0.03,
          child: SvgPicture.asset(fit: BoxFit.contain, iconPath),
        ),
        Text(description),
        const Spacer(),
        IconButton(
          onPressed: onPressed,
          icon: const Icon(CupertinoIcons.right_chevron),
        )
      ],
    );
  }
}
