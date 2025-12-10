class Post {
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String text;
  final String? imageUrl;
  final String location;
  final int likes;
  final int comments;

  Post({
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    required this.text,
    this.imageUrl,
    required this.location,
    required this.likes,
    required this.comments,
  });
}