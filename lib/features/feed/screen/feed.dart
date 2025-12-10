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
        eventType: "Alluvione",
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
        authorName: 'Luca Bianchi',
        authorRole: 'Soccorritore',
        eventType: "Emergenza Idrica",
        timeAgo: '1h fa',
        text:
            'Emergenza idrica in corso nella zona nord della città. Stiamo distribuendo bottiglie d\'acqua presso il centro comunitario. Venite a prenderle se ne avete bisogno!',
        imageUrl:
            'https://www.scienzainrete.it/files/styles/molto_grande/public/hurricane-irma-ea80c77ac527f450.jpg?itok=kSr-QrgV',
        location: 'Centro Comunitario, Zona Nord',
        upvotes: 30,
        comments: 5,
      ),
      Post(
        id: 3,
        authorName: 'Sara Verdi',
        authorRole: 'Cittadina',
        eventType: "Acquazzone",
        timeAgo: '30m fa',
        text:
            'Ho notato che molte persone stanno avendo difficoltà a trovare cibo nelle vicinanze. Ho creato una lista di punti di distribuzione alimentare nella nostra area. Contattatemi per maggiori dettagli!',
        imageUrl:
            'https://www.scienzainrete.it/files/styles/molto_grande/public/hurricane-irma-ea80c77ac527f450.jpg?itok=kSr-QrgV',
        location: 'Via Roma, Centro Città',
        upvotes: 25,
        comments: 8,
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
            PostCard(
              post: p,
              onTap: () {
                print('Post di ${p.authorName} selezionato, ID: ${p.id}');
              },
            ),
        ],
      ),
    );
  }
}
