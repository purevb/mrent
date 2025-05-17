import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mrent/components/button.dart';
import 'package:mrent/controller/data_controller.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/property_model.dart';
import 'package:mrent/pages/update_properties_field/component/location_selector.dart';
import 'package:mrent/pages/update_properties_field/component/property_gallery_image.dart';
import 'package:mrent/pages/update_properties_field/component/property_type_selector.dart';
import 'package:mrent/pages/update_properties_field/component/province_dropdown.dart';
import 'package:mrent/pages/booking_page/component/booking_period_chooser.dart';
import 'package:mrent/pages/update_properties_field/component/text_editing_component.dart';
import 'package:mrent/pages/update_properties_field/component/property_image_uploader.dart';
import 'package:mrent/utils/constants.dart';

class UpdatePropertiesPage extends StatefulWidget {
  const UpdatePropertiesPage({required this.propertyData, super.key});

  final PropertyModel propertyData;

  @override
  State<UpdatePropertiesPage> createState() => _UpdatePropertiesPageState();
}

class _UpdatePropertiesPageState extends State<UpdatePropertiesPage> {
  final TextEditingController nightlyPriceController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController bathroomController = TextEditingController();
  final TextEditingController bedController = TextEditingController();
  final TextEditingController humanController = TextEditingController();
  final TextEditingController roomController = TextEditingController();

  final Api api = Api();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final DataController dataController = DataController();

  String? _selectedProvince;
  String? selectedPropertyCategory;
  String? propertyTypeId;
  LatLng? _selectedLocation;
  String _selectedAddress = "";

  List<File> _selectedImages = [];
  List<String> _existingImages = [];
  List<String> _uploadedImageUrls = [];

  DateTime? _firstSelectedDay;
  DateTime? _secondSelectedDay;

  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _existingImages = widget.propertyData.images?.toList() ?? [];
    dataController.getPropertyTypeDatas();
    dataController.getProvinceData();
  }

  void onProvinceChanged(String? value) {
    if (value != null) {
      setState(() {
        _selectedProvince = value;
      });
    }
  }

  void onLocationSelected(LatLng location, String address) {
    setState(() {
      _selectedLocation = location;
      _selectedAddress = address;
    });
  }

  void onPropertyTypeSelected(String typeName, String typeId) {
    setState(() {
      selectedPropertyCategory = typeName;
      propertyTypeId = typeId;
    });
  }

  void onImagesChanged(List<File> selectedImages, List<String> existingImages,
      List<String> uploadedUrls) {
    setState(() {
      _selectedImages = selectedImages;
      _existingImages = existingImages;
      _uploadedImageUrls = uploadedUrls;
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _saveProperty() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: CircularProgressIndicator(
            color: mRed,
          ),
        ),
      );

      int? guests = humanController.text.isNotEmpty
          ? int.tryParse(humanController.text)
          : null;
      int? beds = bedController.text.isNotEmpty
          ? int.tryParse(bedController.text)
          : null;
      int? rooms = roomController.text.isNotEmpty
          ? int.tryParse(roomController.text)
          : null;
      int? bathrooms = bathroomController.text.isNotEmpty
          ? int.tryParse(bathroomController.text)
          : null;

      bool imagesChanged = _selectedImages.isNotEmpty ||
          (_existingImages.length != widget.propertyData.images?.length);

      List<String>? finalImages;
      if (imagesChanged) {
        if (_selectedImages.isEmpty) {
          finalImages = _existingImages;
        } else {
          final imageUploader = PropertyImageUploader();
          finalImages = await imageUploader.uploadImages(_selectedImages);
          finalImages = [..._existingImages, ...finalImages];
        }
      } else {
        finalImages = null;
      }

      final PropertyModel updatedProperty = await api.updatePropertyData(
        propertyId: widget.propertyData.id ?? "",
        propertyTypeId: propertyTypeId,
        placeTypeId: _selectedProvince,
        nightlyPrice: nightlyPriceController.text,
        propertyName: nameController.text,
        description: descriptionController.text,
        numGuests: guests,
        numBeds: beds,
        numBedrooms: rooms,
        numBathrooms: bathrooms,
        longtitude: _selectedLocation?.longitude,
        lattitude: _selectedLocation?.latitude,
        startDate: _firstSelectedDay,
        endDate: _secondSelectedDay,
        images: finalImages,
      );

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Амжилттай"),
          backgroundColor: Colors.green,
        ),
      );

      // ignore: use_build_context_synchronously
      Navigator.pop(context, updatedProperty);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
    } catch (e) {
      // ignore: use_build_context_synchronously
      Navigator.pop(context);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
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
              PropertyImageGallery(
                selectedImages: _selectedImages,
                existingImages: _existingImages,
                onImagesChanged: onImagesChanged,
              ),
              PropertyTypeSelector(
                dataController: dataController,
                selectedPropertyCategory: selectedPropertyCategory,
                onPropertyTypeSelected: onPropertyTypeSelected,
              ),
              TextEditingComponent(
                controller: nameController,
                title: "Сууцын нэр өөрчлөх",
                hintText: widget.propertyData.propertyName.toString(),
              ),
              TextEditingComponent(
                controller: descriptionController,
                title: "Сууцын тайлбар өөрчлөх",
                hintText: widget.propertyData.description.toString(),
              ),
              _buildPropertyCountFields(width),
              ProvinceDropdown(
                dataController: dataController,
                formKey: _formKey,
                selectedProvince: _selectedProvince,
                onProvinceChanged: onProvinceChanged,
              ),
              LocationSelector(
                selectedAddress: _selectedAddress,
                onLocationSelected: onLocationSelected,
                height: height,
                width: width,
              ),
              TextEditingComponent(
                controller: nightlyPriceController,
                title: "Түрээсэлж буй сууцын үнэ өөрчлөх",
                hintText: widget.propertyData.nightlyPrice.toString(),
              ),
              MyButton(
                canPress: true,
                onPress: _saveProperty,
                height: 50,
                width: width,
                text: "Хадгалах",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPropertyCountFields(double width) {
    return Wrap(
      spacing: 10,
      children: [
        SizedBox(
          width: width * 0.5 - 21,
          child: TextEditingComponent(
            title: "Сууцын нойлын өрөөний тоог өөрчлөх",
            hintText: widget.propertyData.numBathrooms.toString(),
            controller: bathroomController,
          ),
        ),
        SizedBox(
          width: width * 0.5 - 21,
          child: TextEditingComponent(
            title: "Сууцын түрээсийн орны тоог өөрчлөх",
            hintText: widget.propertyData.numBeds.toString(),
            controller: bedController,
          ),
        ),
        SizedBox(
          width: width * 0.5 - 21,
          child: TextEditingComponent(
            title: "Сууцын түрээсийн хүний тоог өөрчлөх",
            hintText: widget.propertyData.numGuests.toString(),
            controller: humanController,
          ),
        ),
        SizedBox(
          width: width * 0.5 - 21,
          child: TextEditingComponent(
            controller: roomController,
            title: "Сууцын түрээсийн өрөөний тоог өөрчлөх",
            hintText: widget.propertyData.numBedrooms.toString(),
          ),
        ),
      ],
    );
  }
}
