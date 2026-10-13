import 'dart:io';

import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final File image;

  const ImagePreview({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.file(image, fit: BoxFit.cover),
      ),
    );
  }
}
