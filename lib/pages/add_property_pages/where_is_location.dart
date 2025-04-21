import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/pages/add_property_pages/add_property_photo.dart';
import 'package:mrent/pages/map_pages/google_maps.dart';
import 'package:mrent/utils/constants.dart';

class WhereIsLocation extends StatefulWidget {
  const WhereIsLocation({
    required this.propertyName,
    required this.propertyTypeId,
    super.key,
  });
  final String propertyTypeId;
  final String propertyName;

  @override
  State<WhereIsLocation> createState() => _WhereIsLocationState();
}

class _WhereIsLocationState extends State<WhereIsLocation> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  LatLng? _selectedLocation;
  DataController dataController = DataController();
  String _selectedAddress = "";
  String? _selectedProvince;

  @override
  void initState() {
    super.initState();
    dataController.getProvinceData();
  }

  void onProvinceChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedProvince = value;
      });
    }
  }

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
      body: ValueListenableBuilder(
          valueListenable: dataController.proviceNotifier,
          builder: (context, provinceData, child) {
            if (provinceData == null) {
              return Center(
                child: CircularProgressIndicator(
                  color: mRed,
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 10, bottom: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: DropdownButtonFormField<String>(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[50],
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xff8BC83F)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            gapPadding: 10,
                            borderRadius: BorderRadius.circular(12),
                            borderSide:
                                const BorderSide(color: Color(0xff8BC83F)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                                color: Color(0xff8BC83F), width: 1.5),
                          ),
                          hintText: "Хот эсвэл аймаг сонгоно уу",
                          hintStyle: TextStyle(color: Colors.grey[600]),
                        ),
                        value: _selectedProvince,
                        isExpanded: false,
                        icon: Icon(Icons.keyboard_arrow_down_rounded,
                            color: Colors.grey[600]),
                        borderRadius: BorderRadius.circular(12),
                        elevation: 19,
                        dropdownColor: Colors.white,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w500,
                        ),
                        items: provinceData
                            .map<DropdownMenuItem<String>>((province) {
                          return DropdownMenuItem<String>(
                            value: province.id,
                            child: Text(
                              province.provinceName ?? "",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey[800],
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: onProvinceChanged,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Хот эсвэл аймаг сонгоно уу';
                          }
                          return null;
                        },
                      ),
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
                                hasFloatButton: true,
                                hasAppBar: false,
                                onLocationSelected:
                                    (LatLng location, String address) {
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
                        if (_selectedLocation != null &&
                            _selectedProvince != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return AddPropertyPhoto(
                                  propertyName: widget.propertyName,
                                  propertyTypeId: widget.propertyTypeId,
                                  longtitude: _selectedLocation!.longitude,
                                  lattitude: _selectedLocation!.latitude,
                                  provinceID: _selectedProvince ?? "",
                                );
                              },
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Байршил болон хаягаа сонгоно уу."),
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
              );
            }
          }),
    );
  }
}
