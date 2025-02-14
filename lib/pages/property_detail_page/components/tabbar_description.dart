import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

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
      width: width * 0.2,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(widget.icon, color: mRed, size: 24),
          const SizedBox(height: 8),
          Text(
            widget.value,
            style: TextStyle(
              color: mRed,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            widget.label,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
