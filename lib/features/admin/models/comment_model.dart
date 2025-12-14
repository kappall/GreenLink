class CommentModel {
  final int id;
  final String text;
  final int userId;
  final int postId;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.text,
    required this.userId,
    required this.postId,
    required this.createdAt,
  });
}
