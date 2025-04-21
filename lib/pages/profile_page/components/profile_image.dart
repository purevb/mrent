import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mrent/core/services/api.dart';
import 'package:mrent/model/mongo_user_model.dart';
import 'package:mrent/utils/constants.dart';
import 'package:uuid/uuid.dart';
import 'package:path/path.dart' as path;

class ProfileImage extends StatefulWidget {
  const ProfileImage({
    required this.proImage,
    super.key,
    required this.mongoUser,
  });
  final String proImage;
  final MongoUserModel mongoUser;

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  Api api = Api();
  bool _isUploading = false;
  String? _selectedImagePath;
  String _uploadedImageUrl = "";
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = const Uuid();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _pickImageFromGallery() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1280,
        maxHeight: 720,
        imageQuality: 80,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImagePath = pickedFile.path;
        });
        _uploadImage();
      } else {
        log("No image selected.");
      }
    } catch (e) {
      log("Error picking image from gallery: $e");
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImagePath == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      File imageFile = File(_selectedImagePath!);
      String fileName = '${_uuid.v4()}${path.extension(_selectedImagePath!)}';
      Reference ref = _storage.ref().child('profile_images/$fileName');
      UploadTask uploadTask = ref.putFile(imageFile);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        progress = progress.clamp(0.0, 1.0);
      });

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();

      setState(() {
        _uploadedImageUrl = downloadUrl;
        _isUploading = false;
      });
      log("Successfully uploaded profile image: $downloadUrl");
      api
          .updateMongoUsersDetail(
        widget.mongoUser.id ?? "",
        userProfile: downloadUrl,
      )
          .then((_) {
        return Navigator.pop(context);
      });
    } catch (e) {
      log("Error uploading image: $e");
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        SizedBox(
          height: 90,
          width: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: _isUploading
                ? Center(
                    child: CircularProgressIndicator(
                    color: mRed,
                  ))
                : (_selectedImagePath != null
                    ? Image.file(File(_selectedImagePath!), fit: BoxFit.cover)
                    : CachedNetworkImage(
                        imageUrl: widget.proImage,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.person,
                          size: 50,
                        ),
                      )),
          ),
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: textDefaultColor,
            ),
            child: IconButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              icon: const Icon(
                CupertinoIcons.pencil_circle,
                size: 20,
              ),
              color: Colors.white,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ),
        )
      ],
    );
  }
}
