import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TabbarDescription extends StatefulWidget {
  const TabbarDescription(
      {required this.value,
      required this.label,
      required this.icon,
      super.key});
  final String value;
  final String label;
  final IconData icon;

  @override
  State<TabbarDescription> createState() => _TabbarDescriptionState();
}

class _TabbarDescriptionState extends State<TabbarDescription> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.all(5),
      width: width * 0.25 - 35,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        spacing: 2,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: Colors.black, size: 24),
          Text(
            widget.value,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            widget.label,
            style: GoogleFonts.inter(
              color: Colors.black,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
