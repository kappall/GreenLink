class Post {
  final int id;
  final String authorName;
  final String authorRole;
  final String timeAgo;
  final String text;
  final String? imageUrl;
  final String location;
  final int upvotes;
  final int comments;

  Post({
    required this.id,
    required this.authorName,
    required this.authorRole,
    required this.timeAgo,
    required this.text,
    this.imageUrl,
    required this.location,
    required this.upvotes,
    required this.comments,
  });
}