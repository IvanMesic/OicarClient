import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/stats_service_provider.dart';

class StatsView extends ConsumerWidget {
  final int langId;

  const StatsView({required this.langId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(statsProvider(langId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Stats'),
      ),
      body: statsAsyncValue.when(
        data: (stats) {
          return ListView.builder(
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final stat = stats[index];
              return ListTile(
                title: Text(stat.statName),
                subtitle: Text(stat.score.toString()),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
