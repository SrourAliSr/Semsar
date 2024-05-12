import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class PhotoViewerPage extends StatefulWidget {
  final List images;
  const PhotoViewerPage({
    super.key,
    required this.images,
  });

  @override
  State<PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<PhotoViewerPage> {
  late List<MemoryImage> memImages;

  @override
  void initState() {
    List<MemoryImage> localMemImages = [];

    for (int i = 0; i < widget.images.length; i++) {
      MemoryImage bytes = widget.images[i].image;

      localMemImages.add(bytes);
    }
    memImages = localMemImages;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: PhotoViewGallery.builder(
        backgroundDecoration: const BoxDecoration(color: Colors.white),
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: memImages[index],
            initialScale: PhotoViewComputedScale.contained,
          );
        },
        itemCount: widget.images.length,
        loadingBuilder: (context, event) => Center(
          child: SizedBox(
            width: 20.0,
            height: 20.0,
            child: CircularProgressIndicator(
              value: event == null
                  ? 0
                  : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
            ),
          ),
        ),
      ),
    );
  }
}
