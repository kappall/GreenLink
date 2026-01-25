import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/post_provider.dart';

void showFilterDialog(
  BuildContext context,
  WidgetRef ref,
  PostFilter currentFilter,
  VoidCallback fun,
) {
  final locationController = TextEditingController(
    text: currentFilter.locationQuery,
  );
  DateTime? selectedDate = currentFilter.startDate;

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text("Filtra Post"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: locationController,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(
                      labelText: "Posizione (es. Milano)",
                      hintText: "Inserisci città per la vicinanza",
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Text("Dal giorno: "),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate ?? DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => selectedDate = picked);
                          }
                        },
                        child: Text(
                          selectedDate == null
                              ? "Seleziona"
                              : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                        ),
                      ),
                      if (selectedDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () => setState(() => selectedDate = null),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Annulla"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await ref
                      .read(postFilterProvider.notifier)
                      .updateFilter(
                        locationQuery: locationController.text,
                        startDate: selectedDate,
                        clearDate: selectedDate == null,
                      );
                  fun();
                  if (context.mounted) Navigator.pop(context);
                },
                child: const Text("Applica"),
              ),
            ],
          );
        },
      );
    },
  );
}
