import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/waste_classes.dart';
import '../bloc/dataset_stats_bloc.dart';

class DatasetStatsPage extends StatelessWidget {
  const DatasetStatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dataset Statistics')),
      body: BlocBuilder<DatasetStatsBloc, DatasetStatsState>(
        builder: (context, state) {
          if (state is DatasetStatsInitial ||
              state is DatasetStatsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is DatasetStatsFailure) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48),

                    const SizedBox(height: 12),

                    Text(state.message, textAlign: TextAlign.center),

                    const SizedBox(height: 16),

                    FilledButton(
                      onPressed: () {
                        context.read<DatasetStatsBloc>().add(
                          DatasetStatsRequested(),
                        );
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is DatasetStatsLoaded) {
            final stats = state.stats;

            return RefreshIndicator(
              onRefresh: () async {
                final bloc = context.read<DatasetStatsBloc>();

                bloc.add(DatasetStatsRequested());

                await bloc.stream.firstWhere(
                      (state) =>
                  state is DatasetStatsLoaded ||
                      state is DatasetStatsFailure,
                );
              },
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            '${stats.totalImages}',
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                          const Text('Total Images'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ...WasteClasses.values.map((wasteClass) {
                    final count = stats.classes[wasteClass] ?? 0;

                    return Card(
                      child: ListTile(
                        title: Text(WasteClasses.displayName(wasteClass)),
                        trailing: Text(
                          '$count',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
