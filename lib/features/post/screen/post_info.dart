
import 'package:greenlinkapp/features/feed/domain/post.dart';
import 'package:flutter/material.dart';
class PostInfoScreen extends StatelessWidget {
  final Post post;

  const PostInfoScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.eventType),
      ),
    );
  }
}