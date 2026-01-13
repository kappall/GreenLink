import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

part 'comment_provider.g.dart';

enum CommentSortCriteria { recent, mostLiked }

@Riverpod(keepAlive: true)
class CommentSort extends _$CommentSort {
  @override
  CommentSortCriteria build() => CommentSortCriteria.recent;

  void setCriteria(CommentSortCriteria criteria) {
    state = criteria;
  }
}

@Riverpod(keepAlive: true)
class Comments extends _$Comments {
  final _commentService = CommentService.instance;
  @override
  FutureOr<List<CommentModel>> build(int contentId) async {
    final criteria = ref.watch(commentSortProvider);

    final comments = await _fetchComments(contentId);

    return _sortComments(comments, criteria);
  }

  Future<List<CommentModel>> _fetchComments(int contentId) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;

    return _commentService.fetchComments(contentId: contentId, token: token);
  }

  List<CommentModel> _sortComments(
    List<CommentModel> list,
    CommentSortCriteria criteria,
  ) {
    final sortedList = List<CommentModel>.from(list);

    if (criteria == CommentSortCriteria.recent) {
      sortedList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } else {
      sortedList.sort((a, b) => b.votesCount.compareTo(a.votesCount));
    }

    return sortedList;
  }

  Future<void> addComment(String description, int? replyTo) async {
    final token = ref.read(authProvider).asData?.value.token;
    if (token == null) return;

    await _commentService.postComment(
      token: token,
      contentId: contentId,
      description: description,
    );

    ref.invalidateSelf();
  }

  Future<void> deleteComment(int commentId) async {
    final token = ref.read(authProvider).asData?.value.token;
    if (token == null) return;

    await _commentService.deleteComment(token: token, commentId: commentId);
    ref.invalidateSelf();
  }

  Future<void> voteComment(int commentId, bool hasVoted) async {
    final authState = ref.read(authProvider).value;
    if (authState == null || authState.token == null) return;

    final previousState = state;

    if (state.hasValue) {
      state = AsyncValue.data(
        state.value!.map((comment) {
          if (comment.id == commentId) {
            final isCurrentlyVoted = comment.hasVoted;
            return comment.copyWith(
              hasVoted: !isCurrentlyVoted,
              votesCount: isCurrentlyVoted
                  ? comment.votesCount - 1
                  : comment.votesCount + 1,
            );
          }
          return comment;
        }).toList(),
      );
    }

    try {
      await _commentService.voteComment(
        token: authState.token!,
        commentId: commentId,
        hasVoted: hasVoted,
      );
    } catch (e) {
      state = previousState;
    }
  }
}

@Riverpod(keepAlive: true)
Future<List<CommentModel>> commentsByUserId(Ref ref, int userId) async {
  final authState = ref.watch(authProvider);
  final token = authState.asData?.value.token;

  return CommentService.instance.fetchCommentsByUserId(
    userId: userId,
    token: token,
  );
}
