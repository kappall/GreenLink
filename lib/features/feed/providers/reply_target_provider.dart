// serve a capire a cosa commentare
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'reply_target_provider.g.dart';

// Lo stato è un Record opzionale: (id del commento, nome autore)
typedef ReplyTargetState = (int? commentId, String? userName)?;

@riverpod
class ReplyTarget extends _$ReplyTarget {
  @override
  ReplyTargetState build() => null; // Di default nessun target (commento al post)

  void setTarget(int commentId, String userName) {
    state = (commentId, userName);
  }

  void reset() {
    state = null;
  }
}
