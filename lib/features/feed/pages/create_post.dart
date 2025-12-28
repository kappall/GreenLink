import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/feed/models/post_model.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../widgets/button.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  PostCategory? selectedCategory;
  final TextEditingController _descriptionController = TextEditingController();
  int charCount = 0;
  final List<XFile> _selectedImages = [];
  final ImagePicker _picker = ImagePicker();

  bool _canPublish() {
    return selectedCategory != null &&
        _selectedImages.isNotEmpty &&
        _descriptionController.text.trim().isNotEmpty;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _updateCharCount(String text) {
    setState(() {
      charCount = text.length;
    });
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Errore nel caricamento delle immagini: $e')),
        );
      }
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canPublish = _canPublish();

    return Scaffold(
      appBar: AppBar(title: const Text('Crea Post')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Text(
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
                      onTap: () {
                        setState(() {
                          selectedCategory = category;
                        });
                      },
                      child: UiBadge(
                        label: category.label,
                        icon: category.icon,
                        color: category.color,
                        isOutline: selectedCategory == category,
                      ),
                    ),
                  )
                  .toList(),
            ),
            Divider(height: 32),
            Center(
              child: const Text(
                'Inserisci una o più foto',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            if (_selectedImages.isNotEmpty)
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _selectedImages.length,
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
                              File(_selectedImages[index].path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 4,
                          right: 12,
                          child: GestureDetector(
                            onTap: () => _removeImage(index),
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
                onPressed: _pickImages,
                icon: const Icon(Icons.add_photo_alternate),
                label: Text(
                  _selectedImages.isEmpty
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
            Divider(height: 32),
            Center(
              child: const Text(
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
              onChanged: _updateCharCount,
            ),
            ButtonWidget(
              label: '  Pubblica Post',
              onPressed: canPublish
                  ? () {
                      
                    }
                  : null,
              icon: const Icon(Icons.send),
            ),
            
          ],
        ),
      ),
    );
  }
}
