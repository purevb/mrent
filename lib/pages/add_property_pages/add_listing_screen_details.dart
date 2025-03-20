import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mrent/utils/constants.dart';

class AddListingScreen extends StatefulWidget {
  const AddListingScreen({
    required this.text,
    required this.type,
    required this.longtitude,
    required this.lattitude,
    required this.photos,
    super.key,
  });
  final String type;
  final String text;
  final String longtitude;
  final String lattitude;
  final List<File> photos;

  @override
  State<AddListingScreen> createState() => _AddListingScreenState();
}

class _AddListingScreenState extends State<AddListingScreen> {
  final TextEditingController rentController = TextEditingController();
  final TextEditingController additionalController = TextEditingController();
  bool _validate = false;
  int bedRoomsCount = 0;
  int bathroomCount = 3;
  String sellPrice = '';
  String rentPrice = '';

  @override
  void initState() {
    print(widget.text);
    print(widget.type);
    print(widget.lattitude);
    print(widget.longtitude);
    print(widget.photos);

    super.initState();
  }

  @override
  void dispose() {
    rentController.dispose();
    additionalController.dispose();
    super.dispose();
  }

  final Map<String, int> propertyFeatures = {
    'Bedroom': 3,
    'Bathroom': 2,
    'Balcony': 2,
  };

  @override
  Widget build(BuildContext context) {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceField("Өдрийн түрээс", "₮ 30000", (value) {
              setState(() {
                rentPrice = value;
              });
            }),
            const SizedBox(height: 20),
            const Text(
              "Бусад",
              style: TextStyle(
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
            const SizedBox(height: 20),
            const Text(
              "Нэмэлт тайлбар",
              style: TextStyle(
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
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    _validate = rentController.text.isEmpty ||
                        additionalController.text.isEmpty;
                  });
                  if (rentController.text.isNotEmpty &&
                      additionalController.text.isNotEmpty) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: height * 0.5,
                          child: Column(
                            children: [
                              Text("Sell Price: $sellPrice"),
                              Text("Rent Price: $rentPrice"),
                              Text(widget.text),
                              Text(widget.type),
                              Text(widget.lattitude),
                              Text(widget.longtitude),
                              Text(widget.photos.toString()),
                              Text(rentController.text),
                              Text(additionalController.text),
                            ],
                          ),
                        );
                      },
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
                child: const Text(
                  "Дуусгах",
                  style: TextStyle(
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
          style: const TextStyle(
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
              const Text(
                "₮",
                style: TextStyle(
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
