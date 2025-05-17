import 'dart:developer';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/pages/add_property_pages/add_listing_screen_details.dart';
import 'package:mrent/utils/constants.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';

class AddPropertyPhoto extends StatefulWidget {
  const AddPropertyPhoto({
    required this.propertyName,
    required this.propertyTypeId,
    required this.longtitude,
    required this.lattitude,
    required this.provinceID,
    this.existingImageUrls = const [],
    super.key,
  });
  final String propertyTypeId;
  final String propertyName;
  final double longtitude;
  final double lattitude;
  final String provinceID;
  final List<String> existingImageUrls;

  @override
  State<AddPropertyPhoto> createState() => _AddPropertyPhotoState();
}

class _AddPropertyPhotoState extends State<AddPropertyPhoto> {
  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  bool _isUploading = false;
  double _uploadProgress = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  @override
  void initState() {
    super.initState();
    _uploadedImageUrls = List.from(widget.existingImageUrls);
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

  void _removeExistingImage(int index) {
    if (_isUploading) return;

    setState(() {
      _uploadedImageUrls.removeAt(index);
    });
  }

  Future<List<String>> _uploadImages() async {
    List<String> newlyUploadedUrls = [];
    int totalImages = _selectedImages.length;
    int completedUploads = 0;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0;
    });

    try {
      for (File imageFile in _selectedImages) {
        try {
          String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
          Reference ref = _storage.ref().child('property_images/$fileName');
          UploadTask uploadTask = ref.putFile(imageFile);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            progress = progress.clamp(0.0, 1.0);
            setState(() {
              _uploadProgress =
                  ((completedUploads + progress) / totalImages).clamp(0.0, 1.0);
            });
          });

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          newlyUploadedUrls.add(downloadUrl);

          completedUploads++;
          setState(() {
            _uploadProgress = (completedUploads / totalImages).clamp(0.0, 1.0);
          });

          log("Successfully uploaded image: $downloadUrl");
        } catch (e) {
          log("Error processing image: $e");
        }
      }

      List<String> allUrls = [..._uploadedImageUrls, ...newlyUploadedUrls];

      setState(() {
        _uploadedImageUrls = allUrls;
        _selectedImages = [];
      });

      return allUrls;
    } catch (e) {
      log("Error during batch upload: $e");
      _showErrorSnackbar("Upload failed: ${e.toString()}");
      rethrow;
    } finally {
      setState(() {
        _isUploading = false;
        _uploadProgress = 0;
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
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_uploadedImageUrls.isNotEmpty) {
          Navigator.pop(context, _uploadedImageUrls);
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text("Зураг нэмэх"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              if (_uploadedImageUrls.isNotEmpty) {
                Navigator.pop(context, _uploadedImageUrls);
              } else {
                Navigator.pop(context);
              }
            },
          ),
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
                    "Зураг нэмэх",
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_uploadedImageUrls.isNotEmpty) ...[
                    Text(
                      "Нэмэгдсэн зурагнууд",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 100,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _uploadedImageUrls.length,
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(_uploadedImageUrls[index]),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 5,
                                right: 15,
                                child: GestureDetector(
                                  onTap: _isUploading
                                      ? null
                                      : () => _removeExistingImage(index),
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
                        },
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Зураг нэмэх",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
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
                              child: const Icon(
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
                                      color: mRed,
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
                              if (_selectedImages.isEmpty &&
                                  _uploadedImageUrls.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddListingScreen(
                                      propertyName: widget.propertyName,
                                      propertyTypeId: widget.propertyTypeId,
                                      longtitude: widget.longtitude,
                                      lattitude: widget.lattitude,
                                      photos: _uploadedImageUrls,
                                      provinceID: widget.provinceID,
                                    ),
                                  ),
                                );
                                return;
                              }

                              if (_selectedImages.isEmpty &&
                                  _uploadedImageUrls.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Ядаж нэг зураг оруулна уу."),
                                  ),
                                );
                                return;
                              }

                              try {
                                List<String> allUrls = await _uploadImages();

                                if (allUrls.isNotEmpty && mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AddListingScreen(
                                        propertyName: widget.propertyName,
                                        propertyTypeId: widget.propertyTypeId,
                                        longtitude: widget.longtitude,
                                        lattitude: widget.lattitude,
                                        photos: _uploadedImageUrls,
                                        provinceID: widget.provinceID,
                                      ),
                                    ),
                                  );
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
                                CircularProgressIndicator(color: mRed),
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
                              "Next",
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
                  value: _uploadProgress.isNaN || _uploadProgress.isInfinite
                      ? null
                      : _uploadProgress,
                  backgroundColor: Colors.grey[300],
                  color: Colors.green,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
