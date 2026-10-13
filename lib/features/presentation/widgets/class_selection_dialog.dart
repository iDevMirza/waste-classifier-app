import 'package:flutter/material.dart';

import '../../../../core/constants/waste_classes.dart';

class ClassSelectionDialog extends StatelessWidget {
  const ClassSelectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select correct category'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.separated(
          shrinkWrap: true,
          itemCount: WasteClasses.values.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final wasteClass = WasteClasses.values[index];

            return ListTile(
              title: Text(WasteClasses.displayName(wasteClass)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.pop(context, wasteClass);
              },
            );
          },
        ),
      ),
    );
  }
}
