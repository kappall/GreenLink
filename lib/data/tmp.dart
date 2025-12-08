import 'package:flutter/material.dart';

enum UserType { citizen, association, institution }

enum PostType { flood, fire, pollution, storm, other }

extension PostTypeExtension on PostType {
  String get label {
    switch (this) {
      case PostType.flood:
        return 'Alluvione';
      case PostType.fire:
        return 'Incendio';
      case PostType.pollution:
        return 'Inquinamento';
      case PostType.storm:
        return 'Tempesta';
      case PostType.other:
        return 'Altro';
    }
  }

  IconData get icon {
    switch (this) {
      case PostType.flood:
        return Icons.water_drop;
      case PostType.fire:
        return Icons.local_fire_department;
      case PostType.pollution:
        return Icons.warning_amber;
      case PostType.storm:
        return Icons.thunderstorm;
      case PostType.other:
        return Icons.info_outline;
    }
  }

  Color get color {
    switch (this) {
      case PostType.flood:
        return Colors.blue;
      case PostType.fire:
        return Colors.red;
      case PostType.pollution:
        return Colors.orange;
      case PostType.storm:
        return Colors.blueGrey;
      case PostType.other:
        return Colors.grey;
    }
  }
}

class Author {
  final String name;
  final UserType type;

  const Author({required this.name, required this.type});
}

class Coordinates {
  final double lat;
  final double lng;

  const Coordinates({required this.lat, required this.lng});
}

class Post {
  final String id;
  final Author author;
  final String content;
  final PostType type;
  final String location;
  final Coordinates coordinates;
  final String timestamp;
  final List<String>? images; // URL immagine
  final int amplifications;
  final int commentsCount;
  final bool isAmplified;

  const Post({
    required this.id,
    required this.author,
    required this.content,
    required this.type,
    required this.location,
    required this.coordinates,
    required this.timestamp,
    this.images = const [],
    this.amplifications = 0,
    this.commentsCount = 0,
    this.isAmplified = false,
  });

  Post copyWith({
    String? id,
    Author? author,
    String? content,
    PostType? type,
    String? location,
    Coordinates? coordinates,
    String? timestamp,
    List<String>? images,
    int? amplifications,
    int? commentsCount,
    bool? isAmplified,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      type: type ?? this.type,
      location: location ?? this.location,
      coordinates: coordinates ?? this.coordinates,
      timestamp: timestamp ?? this.timestamp,
      images: images ?? this.images,
      amplifications: amplifications ?? this.amplifications,
      commentsCount: commentsCount ?? this.commentsCount,
      isAmplified: isAmplified ?? this.isAmplified,
    );
  }
}

enum EventCategory { cleanup, planting, emergency, other }

extension EventCategoryExtension on EventCategory {
  String get label {
    switch (this) {
      case EventCategory.cleanup:
        return 'Pulizia';
      case EventCategory.planting:
        return 'Piantumazione';
      case EventCategory.emergency:
        return 'Emergenza';
      case EventCategory.other:
        return 'Altro';
    }
  }

  IconData get icon {
    switch (this) {
      case EventCategory.cleanup:
        return Icons.cleaning_services;
      case EventCategory.planting:
        return Icons.forest;
      case EventCategory.emergency:
        return Icons.medical_services;
      case EventCategory.other:
        return Icons.volunteer_activism;
    }
  }

  Color get color {
    switch (this) {
      case EventCategory.cleanup:
        return Colors.teal;
      case EventCategory.planting:
        return Colors.green;
      case EventCategory.emergency:
        return Colors.redAccent;
      case EventCategory.other:
        return Colors.indigo;
    }
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  final Author organizer;
  final EventCategory category;
  final String location;
  final String date;
  final String time;
  final Coordinates coordinates;

  const Event({
    required this.id,
    required this.title,
    required this.description,
    required this.organizer,
    required this.category,
    required this.location,
    required this.date,
    required this.time,
    required this.coordinates,
  });
}

final List<Post> mockPosts = [
  Post(
    id: '1',
    author: const Author(
      name: 'Protezione Civile Venezia',
      type: UserType.institution,
    ),
    content:
        'Attenzione: livello del fiume Tuorlo in aumento. Si raccomanda di evitare le zone lungo il corso del fiume e di prestare massima attenzione.',
    type: PostType.flood,
    location: 'Sassi',
    coordinates: const Coordinates(lat: 45.500278, lng: 12.2025),
    timestamp: '10 minuti fa',
    images: [
      'https://images.unsplash.com/photo-1657069343871-fd1476990d04?auto=format&fit=crop&w=1000&q=80',
    ],
    amplifications: 142,
    commentsCount: 28,
  ),
  Post(
    id: '2',
    author: const Author(name: 'Marco Bianchi', type: UserType.citizen),
    content:
        'Avvistato incendio nei pressi di Marghera. Vigili del fuoco già sul posto. Attenzione al fumo.',
    type: PostType.fire,
    location: 'Marghera',
    coordinates: const Coordinates(lat: 45.470278, lng: 12.2425),
    timestamp: '35 minuti fa',
    images: [
      'https://images.unsplash.com/photo-1631240509695-e451b3814df7?auto=format&fit=crop&w=1000&q=80',
    ],
    amplifications: 89,
    commentsCount: 15,
  ),
];

final List<Event> mockEvents = [
  Event(
    id: 'e1',
    title: 'Pulizia Parco Sempione',
    description: 'Ritrovo per pulizia del parco. Guanti forniti.',
    organizer: const Author(name: 'Legambiente', type: UserType.association),
    category: EventCategory.cleanup,
    location: 'Parco Sempione, Milano',
    date: '25 Nov',
    time: '09:00',
    coordinates: const Coordinates(lat: 45.500278, lng: 12.2425),
  ),
  Event(
    id: 'e2',
    title: 'Piantumazione Alberi',
    description: 'Nuovi alberi.',
    organizer: const Author(
      name: 'Comune di Venezia',
      type: UserType.institution,
    ),
    category: EventCategory.planting,
    location: 'Venezia Nord',
    date: '28 Nov',
    time: '10:00',
    coordinates: const Coordinates(lat: 45.490278, lng: 12.2425),
  ),
];
