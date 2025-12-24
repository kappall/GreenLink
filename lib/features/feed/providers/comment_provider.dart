import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../auth/providers/auth_provider.dart';
import '../models/comment_model.dart';
import '../services/comment_service.dart';

part 'comment_provider.g.dart';

enum CommentSortCriteria { recent, mostLiked }

@riverpod
class CommentSort extends _$CommentSort {
  @override
  CommentSortCriteria build() => CommentSortCriteria.recent;

  void setCriteria(CommentSortCriteria criteria) {
    state = criteria;
  }
}

@riverpod
class Comments extends _$Comments {
  final _commentService = CommentService();
  @override
  FutureOr<List<CommentModel>> build(int contentId) async {
    final criteria = ref.watch(commentSortProvider);

    final comments = await _fetchComments(contentId);

    return _sortComments(comments, criteria);
  }

  Future<List<CommentModel>> _fetchComments(int contentId) async {
    final authState = ref.read(authProvider);
    final token = authState.asData?.value.token;

    if (token == null) throw Exception('Autenticazione necessaria');

    return _commentService.fetchComments(contentId: contentId);
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
    //contentId può essere id di un post o di un commento
    final token = ref.read(authProvider).asData?.value.token;
    if (token == null) return;

    await _commentService.postComment(
      token: token,
      contentId: contentId, //il contentId è passato come parametro al provider
      description: description,
    );

    ref.invalidateSelf();
  }
}
