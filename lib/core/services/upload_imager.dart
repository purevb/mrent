import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'dart:developer';

class ImageUtils {
  static final ImageUtils _instance = ImageUtils._internal();
  factory ImageUtils() => _instance;
  ImageUtils._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();
  Future<List<File>> pickImagesFromGallery({
    double maxWidth = 1280,
    double maxHeight = 720,
    int imageQuality = 80,
    Function(String)? onError,
  }) async {
    try {
      final ImagePicker picker = ImagePicker();
      final List<XFile> pickedFiles = await picker.pickMultiImage(
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        imageQuality: imageQuality,
      );

      if (pickedFiles.isNotEmpty) {
        return pickedFiles.map((file) => File(file.path)).toList();
      }
      return [];
    } catch (e) {
      log("Error picking images from gallery: $e");
      if (onError != null) {
        onError("Error picking images: ${e.toString()}");
      }
      return [];
    }
  }

  Future<List<String>> uploadImages({
    required List<File> selectedImages,
    required List<String> existingUrls,
    String storagePath = 'property_images',
    Function(double)? onProgressUpdate,
    Function(String)? onError,
    Function()? onUploadStart,
    Function()? onUploadComplete,
  }) async {
    List<String> newlyUploadedUrls = [];
    int totalImages = selectedImages.length;
    int completedUploads = 0;

    if (onUploadStart != null) {
      onUploadStart();
    }

    if (totalImages == 0) {
      if (onUploadComplete != null) {
        onUploadComplete();
      }
      return existingUrls;
    }

    try {
      for (File imageFile in selectedImages) {
        try {
          String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
          Reference ref = _storage.ref().child('$storagePath/$fileName');
          UploadTask uploadTask = ref.putFile(imageFile);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            progress = progress.clamp(0.0, 1.0);

            if (onProgressUpdate != null) {
              onProgressUpdate(((completedUploads + progress) / totalImages)
                  .clamp(0.0, 1.0));
            }
          });

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          newlyUploadedUrls.add(downloadUrl);

          completedUploads++;
          if (onProgressUpdate != null) {
            onProgressUpdate((completedUploads / totalImages).clamp(0.0, 1.0));
          }

          log("Successfully uploaded image: $downloadUrl");
        } catch (e) {
          log("Error processing image: $e");
          if (onError != null) {
            onError("Error uploading image: ${e.toString()}");
          }
        }
      }

      List<String> allUrls = [...existingUrls, ...newlyUploadedUrls];

      if (onUploadComplete != null) {
        onUploadComplete();
      }

      return allUrls;
    } catch (e) {
      log("Error during batch upload: $e");
      if (onError != null) {
        onError("Upload failed: ${e.toString()}");
      }
      rethrow;
    }
  }
}
