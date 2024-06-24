import 'dart:io';

import 'package:basic_youtube_clone/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<File?> pickImageFromGallery(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return image;
}
Future<File?> pickVideo(BuildContext context, ImageSource source) async {
  File? video;
  try {
    final pickedImage =
        await ImagePicker().pickVideo(source: source);
    if (pickedImage != null) {
      video = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(context: context, content: e.toString());
  }
  return video;
}