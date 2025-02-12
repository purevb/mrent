import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class mAppBar extends StatelessWidget {
  const mAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      shadowColor: Colors.black,
      elevation: 0.8,
      backgroundColor: Colors.white,
      leading: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        icon: SvgPicture.asset(
          "assets/navigationbar/Button.svg",
          width: 20,
          height: 20,
        ),
      ),
      title: const Text(
        "Log in or sign up",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
      ),
      centerTitle: true,
    );
  }
}
