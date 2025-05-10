import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_picker/image_picker.dart';

class PropertyImageGallery extends StatefulWidget {
  final List<File> selectedImages;
  final List<String> existingImages;
  final Function(List<File>, List<String>, List<String>) onImagesChanged;

  const PropertyImageGallery({
    Key? key,
    required this.selectedImages,
    required this.existingImages,
    required this.onImagesChanged,
  }) : super(key: key);

  @override
  State<PropertyImageGallery> createState() => _PropertyImageGalleryState();
}

class _PropertyImageGalleryState extends State<PropertyImageGallery> {
  late List<File> _selectedImages;
  late List<String> _existingImages;
  List<String> _uploadedImageUrls = [];

  @override
  void initState() {
    super.initState();
    _selectedImages = widget.selectedImages;
    _existingImages = widget.existingImages;
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages
              .addAll(pickedFiles.map((file) => File(file.path)).toList());
          widget.onImagesChanged(
              _selectedImages, _existingImages, _uploadedImageUrls);
        });
      }
    } catch (e) {
      log("Error picking images from gallery: $e");
    }
  }

  void _removeExistingImage(int index) {
    setState(() {
      _existingImages.removeAt(index);
      widget.onImagesChanged(
          _selectedImages, _existingImages, _uploadedImageUrls);
    });
  }

  void _removeSelectedImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
      widget.onImagesChanged(
          _selectedImages, _existingImages, _uploadedImageUrls);
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return SizedBox(
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
                        backgroundColor: Colors.white.withOpacity(0.7),
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
                        backgroundColor: Colors.white.withOpacity(0.7),
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
    );
  }
}
