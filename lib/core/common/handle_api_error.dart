import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart';

import '../../features/auth/providers/auth_provider.dart';

Future<void> handleError(Response response, Ref ref) async {
  if (response.statusCode == 401) {
    await ref.read(authProvider.notifier).logout();
  } else {
    throw response;
  }
}
