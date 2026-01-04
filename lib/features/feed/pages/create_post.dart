import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:greenlinkapp/features/feed/providers/post_provider.dart';

import '../../../core/utils/feedback_utils.dart';
import '../widgets/button.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _showLocationDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Inserisci Indirizzo"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "Es: Via Roma 1, Milano",
            helperText: "Specifica città e via per risultati migliori",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () async {
              final address = controller.text.trim();
              if (address.isEmpty) return;

              Navigator.pop(context);
              final success = await ref
                  .read(createPostProvider.notifier)
                  .setManualLocation(address);

              if (!success && mounted) {
                FeedbackUtils.showError(context, "Indirizzo non trovato");
              }
            },
            child: const Text("Cerca"),
          ),
        ],
      ),
    );
  }

  bool get formValid =>
      _descriptionController.text.trim().isNotEmpty &&
      ref.read(createPostProvider).canPublish;

  @override
  Widget build(BuildContext context) {
    final postState = ref.watch(createPostProvider);
    final notifier = ref.read(createPostProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Crea Post')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Scegli la categoria del post',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: PostCategory.values
                    .where((category) => category != PostCategory.unknown)
                    .map(
                      (category) => GestureDetector(
                        onTap: () => notifier.setCategory(category),
                        child: UiBadge(
                          label: category.label,
                          icon: category.icon,
                          color: category.color,
                          isOutline: postState.category == category,
                        ),
                      ),
                    )
                    .toList(),
              ),
              const Divider(height: 32),
              const Center(
                child: Text(
                  'Inserisci una o più foto',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              if (postState.images.isNotEmpty)
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: postState.images.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 8),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                File(postState.images[index].path),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 12,
                            child: GestureDetector(
                              onTap: () => notifier.removeImage(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                padding: const EdgeInsets.all(4),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  onPressed: notifier.pickImages,
                  icon: const Icon(Icons.add_photo_alternate),
                  label: Text(
                    postState.images.isEmpty
                        ? 'Seleziona foto dalla galleria'
                        : 'Aggiungi altre foto',
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              const Divider(height: 32),
              const Center(
                child: Text(
                  'Aggiungi una descrizione',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descriptionController,
                maxLength: 300,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Descrivi la situazione...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const Divider(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Center(
                    child: Text(
                      'Inserisci la posizione',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    postState.locationLabel ?? 'Nessuna posizione selezionata',
                    style: TextStyle(
                      color: postState.locationLabel != null
                          ? Colors.black
                          : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: postState.isLocating
                              ? null
                              : notifier.useCurrentLocation,
                          icon: postState.isLocating
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location_outlined),
                          label: Text(
                            postState.isLocating
                                ? 'Cercando...'
                                : 'posizione attuale',
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: postState.isLocating
                              ? null
                              : _showLocationDialog,
                          icon: const Icon(Icons.edit_location_alt_outlined),
                          label: const Text('Inserisci indirizzo'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ButtonWidget(
                label: postState.isPublishing
                    ? 'Pubblicazione...'
                    : 'Pubblica Post',
                onPressed: formValid
                    ? () async {
                        notifier.setDescription;
                        final success = await notifier.publishPost();
                        if (success && mounted) {
                          context.pop();
                          FeedbackUtils.showSuccess(context, "Post pubblicato");
                        } else if (mounted) {
                          FeedbackUtils.showError(
                            context,
                            "Errore durante la pubblicazione",
                          );
                        }
                      }
                    : null,
                icon: postState.isPublishing
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(Icons.send),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
