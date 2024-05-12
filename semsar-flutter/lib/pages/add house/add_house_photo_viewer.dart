import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:semsar/constants/app_colors.dart';

class AddHousePhotoViewer extends StatelessWidget {
  final File? imageFile;
  final Uint8List? imageBytes;
  final void Function(Uint8List)? deleteImage;
  final bool? iSOwner;
  const AddHousePhotoViewer({
    super.key,
    this.imageFile,
    this.deleteImage,
    this.iSOwner,
    this.imageBytes,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          if (iSOwner != null && iSOwner! == true)
            IconButton(
              onPressed: () {
                deleteImage!(imageBytes!);
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.delete_outline_outlined,
                size: 35,
                color: AppColors.darkBrown,
              ),
            ),
        ],
      ),
      body: (imageFile != null)
          ? PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: FileImage(imageFile!),
            )
          : PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white),
              imageProvider: MemoryImage(imageBytes!),
            ),
    );
  }
}
