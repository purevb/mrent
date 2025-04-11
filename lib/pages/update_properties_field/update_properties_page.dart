import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/property_detail_page/components/map.dart';
import 'package:mrent/pages/update_properties_field/component/text_editing_component.dart';

class UpdatePropertiesPage extends StatefulWidget {
  const UpdatePropertiesPage({required this.propertyData, super.key});

  final PropertyModel propertyData;

  @override
  State<UpdatePropertiesPage> createState() => _UpdatePropertiesPageState();
}

class _UpdatePropertiesPageState extends State<UpdatePropertiesPage> {
  LatLng? _selectedLocation;
  String _selectedAddress = "";
  String? selectedPropertyCategory;
  final List<File> _selectedImages = [];
  List<String> _existingImages = [];
  final Map<int, Map<String, dynamic>> appbarCategoryIcons = {
    0: {
      "icon": "assets/search/amazing_views.png",
      "iconName": "Байгалийн сайхан",
      "iconType": "Nature",
    },
    1: {
      "icon": "assets/search/house.png",
      "iconName": " Байшин",
      "iconType": "House",
    },
    2: {
      "icon": "assets/search/near_river.png",
      "iconName": "Голтой ойрхон",
      "iconType": "River",
    },
    3: {
      "icon": "assets/search/tent.png",
      "iconName": "Майхан",
      "iconType": "Tent",
    },
    4: {
      "icon": "assets/search/yurt.png",
      "iconName": "Гэр",
      "iconType": "Yurts",
    },
  };

  @override
  void initState() {
    super.initState();
    _existingImages = widget.propertyData.images?.toList() ?? [];
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
        });
      }
    } catch (e) {
      log("Error picking images from gallery: $e");
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
    });
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Сууцын мэдээллүүдийг өөрчлөх",
          style: GoogleFonts.inter(
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 10,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.2,
                width: width,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    alignment: WrapAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: _pickImageFromGallery,
                        child: Container(
                          width: width * 0.4,
                          height: width * 0.4,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.add,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      for (int i = 0; i < _selectedImages.length; i++)
                        Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Image.file(
                                _selectedImages[i],
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      // ignore: deprecated_member_use
                                      Colors.white.withOpacity(0.7),
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () => _removeSelectedImage(i),
                                icon: const Icon(
                                  CupertinoIcons.xmark,
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                      for (int i = 0; i < _existingImages.length; i++)
                        Stack(
                          children: [
                            Container(
                              width: width * 0.4,
                              height: width * 0.4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.grey.shade200,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: CachedNetworkImage(
                                imageUrl: _existingImages[i],
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error_outline),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      // ignore: deprecated_member_use
                                      Colors.white.withOpacity(0.7),
                                  shape: const CircleBorder(),
                                ),
                                onPressed: () => _removeExistingImage(i),
                                icon: const Icon(
                                  CupertinoIcons.xmark,
                                  size: 18,
                                ),
                              ),
                            )
                          ],
                        ),
                    ],
                  ),
                ),
              ),
              Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Төрөл өөрчлөх"),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      for (int i = 0; i < appbarCategoryIcons.length; i++)
                        _typeXi(
                          appbarCategoryIcons[i]!['iconName'],
                        ),
                    ],
                  ),
                ],
              ),
              TextEditingComponent(
                title: "Сууцын нэр өөрчлөх",
                hintText: widget.propertyData.propertyName.toString(),
              ),
              TextEditingComponent(
                title: "Сууцын тайлбар өөрчлөх",
                hintText: widget.propertyData.description.toString(),
              ),
              TextEditingComponent(
                title: "Сууцын түрээсийн үнэ өөрчлөх",
                hintText: widget.propertyData.nightlyPrice.toString(),
              ),
              Wrap(
                spacing: 10,
                children: [
                  SizedBox(
                    width: width * 0.5 - 21,
                    child: TextEditingComponent(
                      title: "Сууцын нойлын өрөөний тоог өөрчлөх",
                      hintText: widget.propertyData.numBathrooms.toString(),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5 - 21,
                    child: TextEditingComponent(
                      title: "Сууцын түрээсийн орны тоог өөрчлөх",
                      hintText: widget.propertyData.numBeds.toString(),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5 - 21,
                    child: TextEditingComponent(
                      title: "Сууцын түрээсийн хүний тоог өөрчлөх",
                      hintText: widget.propertyData.numGuests.toString(),
                    ),
                  ),
                  SizedBox(
                    width: width * 0.5 - 21,
                    child: TextEditingComponent(
                      title: "Сууцын түрээсийн өрөөний тоог өөрчлөх",
                      hintText: widget.propertyData.numBedrooms.toString(),
                    ),
                  ),
                ],
              ),
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
                      _selectedAddress.isEmpty
                          ? "Байршилaa өөрчлөх үү."
                          : _selectedAddress,
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
              TextEditingComponent(
                title: "Түрээсэлж буй сууцын үнэ өөрчлөх",
                hintText: widget.propertyData.nightlyPrice.toString(),
              ),
              MyButton(
                  canPress: true,
                  onPress: () {},
                  height: 50,
                  width: width,
                  text: "Хадгалах")
            ],
          ),
        ),
      ),
    );
  }

  Widget _typeXi(String text) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPropertyCategory = text;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        decoration: BoxDecoration(
          color: selectedPropertyCategory == text
              ? const Color(0xff8BC83F)
              : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          text,
          style: GoogleFonts.inter(
            color: const Color(0xff252B5C),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
