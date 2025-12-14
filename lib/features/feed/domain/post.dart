class Post {
  final int id;
  final String authorName;
  final String authorRole;
  final String eventType;
  final String timeAgo;
  final String text;
  final List<String> imageUrl;
  final String location;
  int upvotes;
  final List<String> comments;

  Post({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.eventType,
    required this.timeAgo,
    required this.text,
    required this.imageUrl,
    required this.location,
    required this.upvotes,
    required this.comments,
  });
}