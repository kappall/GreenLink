import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';

import '../../../core/common/widgets/post_card.dart';
import '../models/post_model.dart';

class PostInfoScreen extends StatefulWidget {
  final PostModel p;

  const PostInfoScreen({super.key, required this.p});

  @override
  State<PostInfoScreen> createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends State<PostInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Segnalazione")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCard(post: widget.p),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonWidget(
                    label: "${widget.p.votes.length}",
                    onPressed: () {
                      setState(() {});
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text("0 Commenti", style: const TextStyle(fontSize: 16)),
                ],
              ),

              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  hintText: 'Scrivi un commento...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              for (final comment in ["ciao", "bielo"]) ...[
                SizedBox(
                  width: double.infinity,
                  child: UiCard(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.grey[200],
                          child: Text(
                            'U', // primo carattere del nome utente che verrà preso dal backend
                            style: const TextStyle(
                              fontSize: 24,
                              color: Colors.black54,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'User', // nome utente che verrà preso dal backend
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '· now', // tempo che verrà preso dal backend
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                comment,
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
