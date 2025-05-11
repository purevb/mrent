import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/pages/property_detail_page/components/map.dart';

class LocationSelector extends StatelessWidget {
  final String selectedAddress;
  final Function(LatLng, String) onLocationSelected;
  final double height;
  final double width;

  const LocationSelector({
    Key? key,
    required this.selectedAddress,
    required this.onLocationSelected,
    required this.height,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 10,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Байршлаа оруулна уу.",
          style: GoogleFonts.inter(fontSize: 14),
        ),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 239, 237, 245),
                shape: BoxShape.circle,
              ),
              child: const Icon(CupertinoIcons.location),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                selectedAddress.isEmpty
                    ? "Байршилaa өөрчлөх үү."
                    : selectedAddress,
                style: GoogleFonts.inter(fontSize: 16),
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.5,
          width: width,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                SizedBox(
                  height: height * 0.43,
                  child: MapSample(
                    hasAppBar: false,
                    onLocationSelected: onLocationSelected,
                  ),
                ),
                Container(
                  height: height * 0.07,
                  color: const Color.fromARGB(15, 85, 84, 84),
                  child: Center(
                    child: Text(
                      selectedAddress.isEmpty
                          ? "Байршилaa сонго."
                          : selectedAddress,
                      style: GoogleFonts.inter(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
