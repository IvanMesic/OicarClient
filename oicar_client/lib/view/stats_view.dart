import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../provider/stats_service_provider.dart';

class StatsView extends ConsumerWidget {
  final int langId;

  const StatsView({required this.langId, Key? key}) : super(key: key);

  Future<String?> _getUsername() async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: 'username');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsyncValue = ref.watch(statsProvider(langId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Language Stats'),
      ),
      body: statsAsyncValue.when(
        data: (stats) {
          if (stats.length < 6) {
            return const Center(child: Text('Not enough data available.'));
          }

          // Calculate the values for the new progress bar
          final sum = stats[1].score + stats[3].score + stats[4].score;
          final level = sum ~/ 5;
          final levelProgress = (sum % 5).toDouble();

          return FutureBuilder<String?>(
            future: _getUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              final username = snapshot.data ?? "Username";

              return ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Center(
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage('assets/profile.jpg'),
                        ),
                        const SizedBox(height: 16.0),
                        Text(
                          username,
                          style: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16.0),
                        SizedBox(
                          width: MediaQuery.of(context).size.width *
                              0.4, // 40% of the screen width
                          child: _buildProgressBar(
                            title: 'Level $level',
                            maxValue: 5.0,
                            progressValue: levelProgress,
                          ),
                        ),
                        const SizedBox(height: 32.0),
                      ],
                    ),
                  ),
                  _buildProgressBar(
                    title: 'Fill the blank',
                    maxValue: stats[0].score.toDouble(),
                    progressValue: stats[1].score.toDouble(),
                  ),
                  const SizedBox(height: 16.0),
                  _buildProgressBar(
                    title: 'Flash cards',
                    maxValue: stats[2].score.toDouble(),
                    progressValue: stats[3].score.toDouble(),
                  ),
                  const SizedBox(height: 16.0),
                  _buildProgressBar(
                    title: 'Pick the sentence',
                    maxValue: stats[4].score.toDouble(),
                    progressValue: stats[5].score.toDouble(),
                  ),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildProgressBar({
    required String title,
    required double maxValue,
    required double progressValue,
  }) {
    final progress = (progressValue / maxValue).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          color: Colors.blue,
        ),
        const SizedBox(height: 4.0),
        Text(
          '${(progress * 100).toStringAsFixed(1)}%',
          style: const TextStyle(fontSize: 16.0),
        ),
      ],
    );
  }
}
