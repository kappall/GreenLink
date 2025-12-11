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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostCard(
              post: widget.p,
              showCommentsCount: false,
              showUpvotesCount: false,
            ),
            ButtonWidget(
              label: "${widget.p.upvotes}",
              onPressed: () {
                setState(() {
                  widget.p.upvotes++;
                });
              },
              icon: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
