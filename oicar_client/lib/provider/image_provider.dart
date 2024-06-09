import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/image_service.dart';
import 'basic_providers.dart';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final imageStateProvider =
    StateNotifierProvider<ImageNotifier, AsyncValue<Uint8List>>((ref) {
  return ImageNotifier(ref.read(imageServiceProvider));
});
