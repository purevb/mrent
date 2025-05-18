import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/components/login_dropback/login.dart';
import 'package:mrent/pages/property_detail_page/components/review_component.dart';
import 'package:mrent/providers/property_provider.dart';
import 'package:mrent/utils/constants.dart';
import 'package:path/path.dart' as path;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ReviewTab extends StatefulWidget {
  const ReviewTab({
    required this.propertyId,
    super.key,
  });
  final String propertyId;

  @override
  State<ReviewTab> createState() => _ReviewTabState();
}

class _ReviewTabState extends State<ReviewTab> {
  final TextEditingController _reviewController = TextEditingController();
  final Api api = Api();
  final _refreshController = StreamController<void>.broadcast();
  Stream<void> get refreshStream => _refreshController.stream;

  List<File> _selectedImages = [];
  List<String> _uploadedImageUrls = [];
  bool _isUploading = false;
  double _uploadProgress = 0;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  @override
  void dispose() {
    _reviewController.dispose();
    _refreshController.close();
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage(
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 80,
      );

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(pickedFiles.map((f) => File(f.path)));
        });
      }
    } catch (e) {
      log("Error picking images from gallery: $e");
      _showErrorSnackbar("Error picking images: ${e.toString()}");
    }
  }

  void _removeImage(int index) {
    if (_isUploading) return;
    setState(() => _selectedImages.removeAt(index));
  }

  void _removeExistingImage(int index) {
    if (_isUploading) return;
    setState(() => _uploadedImageUrls.removeAt(index));
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

          uploadTask.snapshotEvents.listen((snapshot) {
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

          log("Uploaded image: $downloadUrl");
        } catch (e) {
          log("Error uploading image: $e");
        }
      }

      List<String> allUrls = [..._uploadedImageUrls, ...newlyUploadedUrls];
      setState(() {
        _uploadedImageUrls = allUrls;
        _selectedImages = [];
      });

      return allUrls;
    } catch (e) {
      log("Batch upload failed: $e");
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
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<void> _postReview() async {
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    if (provider.getUser == null) {
      showModalBottomSheet(
        elevation: 0,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        context: context,
        builder: (BuildContext context) => const Login(),
      );
      return;
    }

    if (_reviewController.text.trim().isEmpty && _selectedImages.isEmpty) {
      _showErrorSnackbar("Please write a review or add images");
      return;
    }

    log('Posting review for propertyId: ${widget.propertyId}, userId: ${provider.fbUser?.id}, text: ${_reviewController.text}');

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Center(child: CircularProgressIndicator(color: mRed)),
    );

    try {
      List<String> imageUrls =
          _selectedImages.isNotEmpty ? await _uploadImages() : [];

      await api.postReview(
        propertyId: widget.propertyId,
        userId: provider.fbUser?.id ?? "",
        text: _reviewController.text.trim(),
        images: imageUrls,
      );

      setState(() {
        _reviewController.clear();
      });

      _refreshController.add(null);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Таны сэтгэгдэл амжилттай бүртгэгдлээ"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      Navigator.pop(context);
      _showErrorSnackbar("Алдаа гарлаа: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    final provider = Provider.of<PropertyProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Text(
          'Сэтгэгдэл',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 10),
        AnimatedContainer(
          height: _selectedImages.isEmpty ? height * 0.2 : height * 0.25,
          duration: const Duration(milliseconds: 200),
          curve: Curves.linear,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black,
                ),
                child: provider.getUser?.profileImage != null
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: provider.getUser?.profileImage ?? "",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person, color: Colors.white),
                        ),
                      )
                    : const Icon(Icons.person, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextField(
                        controller: _reviewController,
                        decoration: const InputDecoration(
                          hintText: "Санал бодлоо хүваалцаарай :)",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        maxLines: 2,
                      ),
                      if (_selectedImages.isNotEmpty)
                        SizedBox(
                          height: 60,
                          child: ListView.separated(
                            padding: const EdgeInsets.only(left: 10, right: 20),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) => Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      _selectedImages[index],
                                      fit: BoxFit.cover,
                                      height: 50,
                                      width: 50,
                                    ),
                                  ),
                                  Positioned(
                                    top: 5,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(index),
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
                              ),
                            ),
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 11),
                            itemCount: _selectedImages.length,
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: _pickImageFromGallery,
                            icon: const Icon(CupertinoIcons.camera),
                          ),
                          if (_isUploading)
                            Expanded(
                              child: LinearProgressIndicator(
                                value: _uploadProgress,
                                backgroundColor: Colors.grey[300],
                                valueColor: AlwaysStoppedAnimation<Color>(mRed),
                              ),
                            )
                          else
                            const Spacer(),
                          IconButton(
                            onPressed: _isUploading ? null : _postReview,
                            icon: Icon(
                              Icons.send,
                              color: _isUploading ? Colors.grey : mRed,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ReviewComponent(
            propertyId: widget.propertyId,
            refreshTrigger: refreshStream,
          ),
        ),
      ],
    );
  }
}
