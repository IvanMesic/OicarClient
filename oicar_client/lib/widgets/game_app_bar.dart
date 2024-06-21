import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final void Function(BuildContext, WidgetRef) exitGame;

  const GameAppBar({Key? key, required this.title, required this.exitGame}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return AppBar(
          title: Text(title),
          automaticallyImplyLeading: false, // Removes the back arrow
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app, color: Colors.red),
              onPressed: () => exitGame(context, ref),
            ),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
