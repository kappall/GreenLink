import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/feed/domain/post.dart';
import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/feed/widgets/postcard.dart';

class PostInfoScreen extends StatefulWidget {
  final Post p;

  const PostInfoScreen({super.key, required this.p});

  @override
  State<PostInfoScreen> createState() => _PostInfoScreenState();
}

class _PostInfoScreenState extends State<PostInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.p.eventType)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PostCard(
                post: widget.p,
                showCommentsCount: false,
                showUpvotesCount: false,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonWidget(
                    label: "${widget.p.upvotes}",
                    onPressed: () {
                      setState(() {
                        widget.p.upvotes++;
                      });
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "(${widget.p.comments.length}) Commenti",
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),

              // comments section
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

              for (final comment in widget.p.comments) ...[
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
                          radius: 22, // diametro = radius * 2
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
