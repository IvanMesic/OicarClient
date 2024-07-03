import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../Notifier/image_notifier.dart';
import '../services/image_service.dart';

final imageServiceProvider = Provider<ImageService>((ref) {
  return ImageService();
});

final imageStateProvider =
    StateNotifierProvider<ImageNotifier, AsyncValue<Uint8List?>>((ref) {
  return ImageNotifier(ref.read(imageServiceProvider));
});
