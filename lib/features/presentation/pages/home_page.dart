import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/waste_classes.dart';
import '../bloc/waste_bloc.dart';
import '../bloc/waste_event.dart';
import '../bloc/waste_state.dart';
import '../widgets/class_selection_dialog.dart';
import '../widgets/image_preview.dart';
import '../widgets/prediction_card.dart';
import 'dataset_stats_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ImagePicker _imagePicker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 90,
    );

    if (image == null || !mounted) {
      return;
    }

    context.read<WasteBloc>().add(WasteImageSelected(File(image.path)));

    context.read<WasteBloc>().add(const WastePredictionRequested());
  }

  Future<void> _showImageSource() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(context, ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(context, ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source != null) {
      await _pickImage(source);
    }
  }

  Future<void> _confirmDatasetSave(WasteState state) async {
    final prediction = state.prediction;

    if (prediction == null) {
      return;
    }

    final isCorrect = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Prediction'),
          content: Text(
            'The model predicted '
            '"${WasteClasses.displayName(prediction.predictedClass)}".\n\n'
            'Is this prediction correct?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('NO'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('YES'),
            ),
          ],
        );
      },
    );

    if (!mounted || isCorrect == null) {
      return;
    }

    if (isCorrect) {
      context.read<WasteBloc>().add(
        WasteDatasetSaveRequested(humanLabel: prediction.predictedClass),
      );

      return;
    }

    final correctClass = await showDialog<String>(
      context: context,
      builder: (_) => const ClassSelectionDialog(),
    );

    if (!mounted || correctClass == null) {
      return;
    }

    context.read<WasteBloc>().add(
      WasteDatasetSaveRequested(humanLabel: correctClass),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Waste Classifier'),
        actions: [
          IconButton(
            tooltip: 'Dataset Statistics',
            icon: const Icon(Icons.bar_chart),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const DatasetStatsPage()),
              );
            },
          ),
        ],
      ),

      body: BlocConsumer<WasteBloc, WasteState>(
        listener: (context, state) {
          if (state.status == WasteStatus.failure &&
              state.errorMessage != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          }

          if (state.status == WasteStatus.saveSuccess &&
              state.saveResult != null) {
            ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                SnackBar(content: Text(state.saveResult!.message)),
              );
          }
        },

        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Smart Waste Classification',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Capture a waste image and let the '
                    'AI classify it.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 24),

                  if (state.image == null)
                    _EmptyImageCard(onPressed: _showImageSource),

                  if (state.image != null) ImagePreview(image: state.image!),

                  const SizedBox(height: 20),

                  if (state.status == WasteStatus.predicting)
                    const Column(
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 12),
                        Text('Classifying image...'),
                      ],
                    ),

                  if (state.prediction != null) ...[
                    PredictionCard(prediction: state.prediction!),

                    const SizedBox(height: 16),

                    FilledButton.icon(
                      onPressed: state.status == WasteStatus.saving
                          ? null
                          : () {
                              _confirmDatasetSave(state);
                            },
                      icon: state.status == WasteStatus.saving
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save_alt),
                      label: Text(
                        state.status == WasteStatus.saving
                            ? 'Saving...'
                            : 'Save it in dataset',
                      ),
                    ),
                  ],

                  if (state.status == WasteStatus.saveSuccess &&
                      state.saveResult != null) ...[
                    const SizedBox(height: 16),

                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            const Icon(Icons.check_circle, size: 40),

                            const SizedBox(height: 8),

                            const Text('Saved Successfully'),

                            const SizedBox(height: 4),

                            Text(
                              'Saved as: '
                              '${WasteClasses.displayName(state.saveResult!.label)}',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  if (state.image != null)
                    OutlinedButton.icon(
                      onPressed: () {
                        context.read<WasteBloc>().add(
                          const WasteResetRequested(),
                        );

                        _showImageSource();
                      },
                      icon: const Icon(Icons.camera_alt),
                      label: const Text('Capture Another Image'),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _EmptyImageCard extends StatelessWidget {
  final VoidCallback onPressed;

  const _EmptyImageCard({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onPressed,
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
          child: Column(
            children: [
              Icon(Icons.camera_alt_outlined, size: 64),
              SizedBox(height: 16),
              Text('Tap to capture waste image'),
            ],
          ),
        ),
      ),
    );
  }
}
