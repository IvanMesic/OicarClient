import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_service.dart';

class ImageNotifier extends StateNotifier<AsyncValue<Uint8List>> {
  final ImageService imageService;

  ImageNotifier(this.imageService) : super(AsyncValue.loading());

  void fetchImage(String imagePath) {
    Future.microtask(() async {
      try {
        final imageData = await imageService.fetchImageData(imagePath);
        state = AsyncValue.data(imageData);
      } catch (e) {
        state = AsyncValue.error(e, StackTrace.current);
      }
    });
  }
}
