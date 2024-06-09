import 'dart:typed_data';

import 'package:dio/dio.dart';

class ImageService {
  final Dio dio = Dio();

  /// Fetches image data directly as `Uint8List` using the correct base URL for static content.
  Future<Uint8List> fetchImageData(String imagePath) async {
    try {
      Response<List<int>> response = await dio.get<List<int>>(
        imagePath,
        options: Options(responseType: ResponseType.bytes),
      );

      print("Response data length: ${response.data?.length} bytes");

      return Uint8List.fromList(response.data!);
    } catch (e) {
      print("Failed to fetch image data: $e");
      rethrow;
    }
  }
}
