import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/pages/add_property_pages/add_listing_screen_details.dart';

class AddPropertyPhoto extends StatefulWidget {
  const AddPropertyPhoto({
    required this.text,
    required this.type,
    required this.longtitude,
    required this.lattitude,
    required this.provinceName,
    super.key,
  });
  final String type;
  final String text;
  final String longtitude;
  final String lattitude;
  final String provinceName;
  @override
  State<AddPropertyPhoto> createState() => _AddPropertyPhotoState();
}

class _AddPropertyPhotoState extends State<AddPropertyPhoto> {
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  bool _isUploading = false;
  double _uploadProgress = 0;
  final Dio _dio = Dio();
  final String _imgBBApiKey = 'a05bc3833add930a77b1e71c555c6b1b';

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
        });
      }
    } catch (e) {
      log("Error picking images from gallery: $e");
      _showErrorSnackbar("Error picking images: ${e.toString()}");
    }
  }

  void _removeImage(int index) {
    if (_isUploading) return;

    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  Future<List<String>> _uploadImages() async {
    List<String> uploadedUrls = [];
    int totalImages = _selectedImages.length;
    int completedUploads = 0;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      for (File imageFile in _selectedImages) {
        try {
          // Read file as bytes
          Uint8List imageBytes = await imageFile.readAsBytes();

          // Convert to base64
          String base64Image = base64Encode(imageBytes);

          // Create form data
          FormData formData = FormData.fromMap({
            "key": _imgBBApiKey,
            "image": base64Image,
          });

          // Upload to imgBB
          Response response = await _dio.post(
            "https://api.imgbb.com/1/upload",
            data: formData,
          );

          if (response.statusCode == 200) {
            // Extract URL from response
            String imageUrl = response.data['data']['display_url'];
            uploadedUrls.add(imageUrl);
            for (int i = 0; i < uploadedUrls.length; i++) {
              print(uploadedUrls[i]);
            }

            completedUploads++;
            setState(() {
              _uploadProgress = completedUploads / totalImages;
            });

            log("Successfully uploaded image: $imageUrl");
          } else {
            log("Error uploading image. Status code: ${response.statusCode}");
            _showErrorSnackbar("Error uploading image. Please try again.");
          }
        } catch (e) {
          log("Error processing image: $e");
          // Continue with next image
        }
      }

      return uploadedUrls;
    } catch (e) {
      log("Error during batch upload: $e");
      _showErrorSnackbar("Upload failed: ${e.toString()}");
      rethrow;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Estate / Photos"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
              left: 20,
              top: 20,
              bottom: 40,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Listing",
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Add photos to your listing",
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: _selectedImages.length + 1,
                    itemBuilder: (context, index) {
                      if (index == _selectedImages.length) {
                        return GestureDetector(
                          onTap: _isUploading ? null : _pickImageFromGallery,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _isUploading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : const Icon(
                                    Icons.add,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                          ),
                        );
                      } else {
                        return Stack(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                _selectedImages[index],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            if (_isUploading)
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: index <
                                            (_uploadProgress *
                                                _selectedImages.length)
                                        ? 1.0
                                        : null,
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 5,
                              right: 5,
                              child: GestureDetector(
                                onTap: _isUploading
                                    ? null
                                    : () => _removeImage(index),
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isUploading
                        ? null
                        : () async {
                            if (_selectedImages.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Ядаж нэг зураг оруулна уу."),
                                ),
                              );
                              return;
                            }

                            try {
                              List<String> urls = await _uploadImages();

                              if (urls.isNotEmpty && mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddListingScreen(
                                      text: widget.text,
                                      type: widget.type,
                                      longtitude: widget.longtitude,
                                      lattitude: widget.lattitude,
                                      photos:
                                          _selectedImages, // You can pass the original files
                                      provinceName: widget.provinceName,
                                      // If your AddListingScreen can accept URLs instead of Files:
                                      // imageUrls: urls,
                                    ),
                                  ),
                                );
                              } else {
                                _showErrorSnackbar(
                                    "Failed to upload images. Please try again.");
                              }
                            } catch (e) {
                              log("Navigation error: $e");
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      backgroundColor: const Color(0xff8BC83F),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: _isUploading
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator(
                                  color: Colors.white),
                              const SizedBox(width: 10),
                              Text(
                                "${(_uploadProgress * 100).toStringAsFixed(0)}%",
                                style: GoogleFonts.inter(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          )
                        : Text(
                            "Дараах",
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
          if (_isUploading)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: LinearProgressIndicator(
                value: _uploadProgress,
                backgroundColor: Colors.grey[300],
                color: Colors.green,
              ),
            ),
        ],
      ),
    );
  }
}
