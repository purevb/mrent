import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/pages/booking_page/component/booking_period_chooser.dart';
import 'package:mrent/pages/naviagation_page.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:provider/provider.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({
    required this.propertyName,
    required this.propertyTypeId,
    required this.longtitude,
    required this.lattitude,
    required this.provinceID,
    required this.photos,
    super.key,
  });
  final String propertyTypeId;
  final String propertyName;
  final double longtitude;
  final double lattitude;
  final List<String> photos;
  final String provinceID;

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;
  Api api = Api();

  final TextEditingController rentController = TextEditingController();
  final TextEditingController additionalController = TextEditingController();
  bool _validate = false;
  int bedRoomsCount = 0;
  int bathroomCount = 0;
  int humanCount = 0;
  int bedCount = 0;

  String sellPrice = '';
  String rentPrice = '';
  int getSelectedDaysDifference() {
    if (_firstSelectedDay != null && _secondSelectedDay != null) {
      return _secondSelectedDay!.difference(_firstSelectedDay!).inDays;
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    rentController.dispose();
    additionalController.dispose();
    super.dispose();
  }

  Future<void> postPropertyAndShowDialog({
    required String provinceId,
    required String propertyTypeId,
    required String userId,
    required TextEditingController rentController,
    required String propertyName,
    required int humanCount,
    required int bedCount,
    required int bedRoomsCount,
    required int bathroomCount,
    required TextEditingController additionalController,
    required double lattitude,
    required double longtitude,
    required DateTime? firstSelectedDay,
    required DateTime? secondSelectedDay,
    required List<String> photos,
    required BuildContext context,
  }) async {
    try {
      final nightlyPrice = int.tryParse(rentController.text) ?? 0;
      final startDate = firstSelectedDay!;
      final endDate = secondSelectedDay!;

      await api.postProperties(
        provinceId: provinceId,
        propertyTypeId: propertyTypeId,
        userId: userId,
        nightlyPrice: nightlyPrice,
        propertyName: propertyName,
        numGuests: humanCount,
        numBeds: bedCount,
        numBedrooms: bedRoomsCount,
        numBathrooms: bathroomCount,
        description: additionalController.text,
        latitude: lattitude,
        longitude: longtitude,
        startDate: startDate,
        endDate: endDate,
        images: photos,
      );

      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Амжилттай!"),
            content: const Text("Үл хөдлөх хөрөнгө амжилттай нэмэгдлээ."),
            actions: [
              TextButton(
                onPressed: () {
                  final user = Provider.of<PropertyProvider>(
                    context,
                    listen: false,
                  ).fbUser;
                  if (user != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NavigationPage(
                            id: user.id,
                            user: user,
                          );
                        },
                      ),
                    );
                  }
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    } catch (error) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Алдаа гарлаа"),
            content: Text("Хадгалах үед алдаа гарлаа:\n$error"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  final Map<String, int> propertyFeatures = {
    'Bedroom': 3,
    'Bathroom': 2,
    'Balcony': 2,
  };

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<PropertyProvider>(context, listen: false);
    double height = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text("Add Listing"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          right: 20,
          left: 20,
          top: 10,
          bottom: 40,
        ),
        child: ListView(
          children: [
            _buildPriceField("Өдрийн түрээс", "₮ 30000", (value) {
              setState(() {
                rentPrice = value;
              });
            }),
            const SizedBox(height: 20),
            Text(
              "Бусад",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            _buildPropertyFeatures(
              "Унтлагын өрөө",
              bedRoomsCount,
              onDecrement: () {
                setState(() {
                  if (bedRoomsCount > 0) bedRoomsCount--;
                });
              },
              onIncrement: () {
                setState(() {
                  bedRoomsCount++;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildPropertyFeatures(
              "Угаалгын өрөө",
              bathroomCount,
              onDecrement: () {
                setState(() {
                  if (bathroomCount > 0) bathroomCount--;
                });
              },
              onIncrement: () {
                setState(() {
                  bathroomCount++;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildPropertyFeatures(
              "Хүн хүлээн авах чадал",
              humanCount,
              onDecrement: () {
                setState(() {
                  if (humanCount > 0) humanCount--;
                });
              },
              onIncrement: () {
                setState(() {
                  humanCount++;
                });
              },
            ),
            const SizedBox(height: 10),
            _buildPropertyFeatures(
              "Ор",
              bedCount,
              onDecrement: () {
                setState(() {
                  if (bedCount > 0) bedCount--;
                });
              },
              onIncrement: () {
                setState(() {
                  bedCount++;
                });
              },
            ),
            const SizedBox(height: 10),
            BookingPeriodChooserComponent(
              forAddProperties: true,
              onDatesSelected: (start, end) {
                setState(() {
                  _firstSelectedDay = start;
                  _secondSelectedDay = end;
                });
              },
            ),
            const SizedBox(height: 20),
            Text(
              "Нэмэлт тайлбар",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              textInputAction: TextInputAction.done,
              controller: additionalController,
              maxLines: 5,
              decoration: InputDecoration(
                errorText: _validate ? "Бүрэн бөглөнө үү." : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color.fromARGB(255, 227, 226, 230),
                filled: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _validate = rentController.text.isEmpty ||
                        additionalController.text.isEmpty;
                  });
                  if (rentController.text.isNotEmpty &&
                      additionalController.text.isNotEmpty) {
                    postPropertyAndShowDialog(
                      provinceId: widget.provinceID,
                      propertyTypeId: widget.propertyTypeId,
                      userId: provider.getUser?.id ?? "",
                      rentController: rentController,
                      propertyName: widget.propertyName,
                      humanCount: humanCount,
                      bedCount: bedCount,
                      bedRoomsCount: bedRoomsCount,
                      bathroomCount: bathroomCount,
                      additionalController: additionalController,
                      lattitude: widget.lattitude,
                      longtitude: widget.longtitude,
                      firstSelectedDay: _firstSelectedDay!,
                      secondSelectedDay: _secondSelectedDay!,
                      photos: widget.photos,
                      context: context,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Forum-ыг бүрэн бөглө."),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: const Color(0xff8BC83F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Дуусгах",
                  style: GoogleFonts.inter(
                    fontSize: 18,
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

  Widget _buildPriceField(
      String label, String hint, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.only(right: 10),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color.fromARGB(255, 227, 226, 230),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: rentController,
                  decoration: InputDecoration(
                    errorText: _validate ? "Бүрэн бөглөнө үү." : null,
                    hintText: hint,
                    filled: true,
                    fillColor: const Color.fromARGB(255, 227, 226, 230),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: onChanged,
                ),
              ),
              Text(
                "₮",
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPropertyFeatures(
    String text,
    int counts, {
    required VoidCallback onDecrement,
    required VoidCallback onIncrement,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 227, 226, 230),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(text),
          const Spacer(),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffA1A5C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onPressed: onDecrement,
            icon: const Icon(
              CupertinoIcons.minus,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 10),
          Text("$counts"),
          const SizedBox(width: 10),
          IconButton(
            style: IconButton.styleFrom(
              backgroundColor: const Color(0xffA1A5C1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
            ),
            onPressed: onIncrement,
            icon: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
