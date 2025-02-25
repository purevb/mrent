import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MappBar extends StatelessWidget {
  const MappBar({
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
          width: 18,
          height: 18,
        ),
      ),
      title: const Text(
        "Нэвтрэх эсвэл бүртгүүлэх",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      centerTitle: true,
    );
  }
}
