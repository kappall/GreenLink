import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_validation_result.freezed.dart';

@freezed
abstract class TicketValidationResult with _$TicketValidationResult {
  const TicketValidationResult._();

  const factory TicketValidationResult.valid() = _TicketValid;
  const factory TicketValidationResult.alreadyUsed() = _TicketAlreadyUsed;
  const factory TicketValidationResult.expired() = _TicketExpired;
  const factory TicketValidationResult.wrongEvent() = _TicketWrongEvent;
  const factory TicketValidationResult.error({String? message}) = _TicketError;
}

extension TicketValidationResultX on TicketValidationResult {
  bool get isError => maybeWhen(error: (_) => true, orElse: () => false);

  String? get errorMessage =>
      maybeWhen(error: (message) => message, orElse: () => null);
}
