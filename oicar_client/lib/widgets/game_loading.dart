import 'package:flutter/material.dart';

class GameLoading extends StatelessWidget {
  final String title;

  const GameLoading({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
