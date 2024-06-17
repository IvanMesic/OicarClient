import 'package:flutter/material.dart';

class GameImage extends StatelessWidget {
  final String imagePath;

  const GameImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imagePath,
      fit: BoxFit.cover,
      width: 350,
      height: 350,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset('assets/logo.png');
      },
    );
  }
}
