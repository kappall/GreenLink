import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

base class AppProviderObserver extends ProviderObserver {
  final _logger = Logger(printer: SimplePrinter(colors: true));

  @override
  void didUpdateProvider(
    ProviderObserverContext pContext,
    Object? previousValue,
    Object? newValue,
  ) {
    _logger.d(
      'Provider ${pContext.provider.name ?? pContext.provider.runtimeType} aggiornato',
    );
  }

  @override
  void providerDidFail(
    ProviderObserverContext pContext,
    Object error,
    StackTrace stackTrace,
  ) {
    _logger.e(
      'Provider ${pContext.provider.name ?? pContext.provider.runtimeType} FALLITO',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
