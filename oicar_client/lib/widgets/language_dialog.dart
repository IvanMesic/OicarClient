import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/language_service.dart';
import '../services/preference_service.dart';

void showLanguageDialog(BuildContext context, WidgetRef ref) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Select Language"),
        content: Consumer(
          builder: (context, ref, child) {
            final languagesAsyncValue = ref.watch(languageListProvider);
            return languagesAsyncValue.when(
              data: (languages) => SizedBox(
                width: double.maxFinite,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: languages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final language = languages[index];
                    return ListTile(
                      title: Text(language.name),
                      onTap: () {
                        ref
                            .read(languageIdProvider.notifier)
                            .selectLanguage(language.id);
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, stack) => Text('Failed to load languages: $e'),
            );
          },
        ),
      );
    },
  );
}
