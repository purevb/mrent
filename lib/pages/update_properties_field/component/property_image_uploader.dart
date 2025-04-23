import 'dart:io';
import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';

class PropertyImageUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final Uuid _uuid = Uuid();

  ValueNotifier<double> uploadProgressNotifier = ValueNotifier(0.0);
  ValueNotifier<bool> isUploadingNotifier = ValueNotifier(false);

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> uploadedUrls = [];
    int totalImages = images.length;
    int completedUploads = 0;

    isUploadingNotifier.value = true;
    uploadProgressNotifier.value = 0.0;

    try {
      for (File imageFile in images) {
        try {
          String fileName = '${_uuid.v4()}${path.extension(imageFile.path)}';
          Reference ref = _storage.ref().child('property_images/$fileName');
          UploadTask uploadTask = ref.putFile(imageFile);

          uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
            double progress = snapshot.bytesTransferred / snapshot.totalBytes;
            progress = progress.clamp(0.0, 1.0);
            uploadProgressNotifier.value =
                ((completedUploads + progress) / totalImages).clamp(0.0, 1.0);
          });

          TaskSnapshot taskSnapshot = await uploadTask;
          String downloadUrl = await taskSnapshot.ref.getDownloadURL();
          uploadedUrls.add(downloadUrl);

          completedUploads++;
          uploadProgressNotifier.value =
              (completedUploads / totalImages).clamp(0.0, 1.0);

          log("Successfully uploaded image: $downloadUrl");
        } catch (e) {
          log("Error processing image: $e");
        }
      }

      return uploadedUrls;
    } catch (e) {
      log("Error during batch upload: $e");
      rethrow;
    } finally {
      isUploadingNotifier.value = false;
      uploadProgressNotifier.value = 0.0;
    }
  }
}
