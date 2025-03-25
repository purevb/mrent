import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/pages/add_property_pages/add_property_photo.dart';
import 'package:mrent/pages/property_detail_page/components/google_maps.dart';

class WhereIsLocation extends StatefulWidget {
  const WhereIsLocation({
    required this.text,
    required this.type,
    super.key,
  });
  final String type;
  final String text;

  @override
  State<WhereIsLocation> createState() => _WhereIsLocationState();
}

class _WhereIsLocationState extends State<WhereIsLocation> {
  LatLng? _selectedLocation;
  String _selectedAddress = "";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Tүрээслүүлэх сууц нэмэх",
          style: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Байршлаа оруулна уу.",
              style: GoogleFonts.inter(fontSize: 24),
            ),
            const SizedBox(height: 10),
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
                    _selectedAddress.isEmpty
                        ? "Байршилaa сонгоно уу."
                        : _selectedAddress,
                    style: GoogleFonts.inter(fontSize: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: height * 0.5,
              width: screenWidth,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Column(
                  children: [
                    SizedBox(
                      height: height * 0.43,
                      child: MapSample(
                        hasAppBar: false,
                        onLocationSelected: (LatLng location, String address) {
                          setState(() {
                            _selectedLocation = location;
                            _selectedAddress = address;
                          });
                        },
                      ),
                    ),
                    Container(
                      height: height * 0.07,
                      color: const Color.fromARGB(15, 85, 84, 84),
                      child: Center(
                        child: Text(
                          _selectedAddress.isEmpty
                              ? "Байршилaa сонго."
                              : _selectedAddress,
                          style: GoogleFonts.inter(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                if (_selectedLocation != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return AddPropertyPhoto(
                          text: widget.text,
                          type: widget.type,
                          longtitude: _selectedLocation!.longitude.toString(),
                          lattitude: _selectedLocation!.latitude.toString(),
                        );
                      },
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Байршилaa сонгоно уу."),
                    ),
                  );
                }
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xff8BC83F),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                alignment: Alignment.center,
                child: Text(
                  "Дараах",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
