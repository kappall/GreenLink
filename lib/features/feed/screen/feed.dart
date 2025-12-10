import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/feed/domain/post.dart';
import 'package:greenlinkapp/features/feed/widgets/postcard.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final List<Post> posts = [
      //hardcoded sample posts
      Post(
        id: 1,
        authorName: 'Giulia Rossi',
        authorRole: 'Volontaria',
        timeAgo: '2h fa',
        text:
            'Ciao community! Sabato organizziamo una pulizia del parco insieme. Ci troviamo alle 9:30 vicino all\'ingresso principale, portate guanti e buona energia!',
        imageUrl:
            'https://www.scienzainrete.it/files/styles/molto_grande/public/hurricane-irma-ea80c77ac527f450.jpg?itok=kSr-QrgV',
        location: 'Parco Sempione, Milano',
        upvotes: 42,
        comments: 12,
      ),
      Post(
        id: 2,
        authorName: 'Giulia Rossi',
        authorRole: 'Volontaria',
        timeAgo: '2h fa',
        text:
            'Ciao community! Sabato organizziamo una pulizia del parco insieme. Ci troviamo alle 9:30 vicino all\'ingresso principale, portate guanti e buona energia!',
        imageUrl:
            'https://www.scienzainrete.it/files/styles/molto_grande/public/hurricane-irma-ea80c77ac527f450.jpg?itok=kSr-QrgV',
        location: 'Parco Sempione, Milano',
        upvotes: 42,
        comments: 12,
      ),
      Post(
        id: 3,
        authorName: 'Giulia Rossi',
        authorRole: 'Volontaria',
        timeAgo: '2h fa',
        text:
            'Ciao community! Sabato organizziamo una pulizia del parco insieme. Ci troviamo alle 9:30 vicino all\'ingresso principale, portate guanti e buona energia!',
        imageUrl:
            'https://www.scienzainrete.it/files/styles/molto_grande/public/hurricane-irma-ea80c77ac527f450.jpg?itok=kSr-QrgV',
        location: 'Parco Sempione, Milano',
        upvotes: 42,
        comments: 12,
      ),
    ];

    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Bacheca Emergenze",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              ButtonWidget(
                label: '+ Nuovo Post',
                onPressed: () {
                  print('Crea Nuovo Post premuto');
                },
              ),
            ],
          ),


          for (final p in posts)
            PostCard(post: p, onTap: () {
                print('Post di ${p.authorName} selezionato, ID: ${p.id}');
              },
            ),
        ],
      ),
    );
  }
}
