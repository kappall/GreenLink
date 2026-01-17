import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_validation_result.freezed.dart';

@freezed
abstract class TicketValidationResult with _$TicketValidationResult {
  const TicketValidationResult._();

  const factory TicketValidationResult.valid({String? userName}) = _TicketValid;
  const factory TicketValidationResult.wrongEvent() = _TicketWrongEvent;
  const factory TicketValidationResult.error({String? message}) = _TicketError;
}

extension TicketValidationResultX on TicketValidationResult {
  bool get isError =>
      when(valid: (_) => false, wrongEvent: () => true, error: (_) => true);

  String? get userName =>
      maybeWhen(valid: (userName) => userName, orElse: () => null);

  String get message {
    return when(
      valid: (userName) =>
          'Accesso autorizzato${userName != null ? ' per $userName' : ''}.',
      wrongEvent: () => 'Biglietto non valido per questo evento.',
      error: (message) =>
          message ?? 'Errore sconosciuto durante la validazione.',
    );
  }
}
