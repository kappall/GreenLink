import 'package:greenlinkapp/features/event/models/ticket_validation_result.dart';
import 'package:greenlinkapp/features/event/services/event_ticket_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'event_ticket_controller.g.dart';

enum EventTicketStatus { idle, loading, success, error }

class EventTicketState {
  final EventTicketStatus status;
  final String ticket;
  final TicketValidationResult? validationResult;

  const EventTicketState({
    this.status = EventTicketStatus.idle,
    this.ticket = '',
    this.validationResult,
  });

  EventTicketState copyWith({
    EventTicketStatus? status,
    String? ticket,
    TicketValidationResult? validationResult,
  }) {
    return EventTicketState(
      status: status ?? this.status,
      ticket: ticket ?? this.ticket,
      validationResult: validationResult ?? this.validationResult,
    );
  }

  bool get isLoading => status == EventTicketStatus.loading;
}

@riverpod
class EventTicketController extends _$EventTicketController {
  bool _isChecking = false;

  @override
  EventTicketState build(String eventId) => const EventTicketState();

  Future<void> participate() async {
    if (state.isLoading) return;

    state = const EventTicketState(status: EventTicketStatus.loading);

    try {
      final ticket = await ref
          .read(eventTicketServiceProvider)
          .participate(eventId: eventId);

      state = EventTicketState(
        status: EventTicketStatus.success,
        ticket: ticket,
      );
    } catch (error) {
      state = EventTicketState(
        status: EventTicketStatus.error,
        validationResult: TicketValidationResult.error(
          message: _normalizeError(error),
        ),
      );
    }
  }

  Future<void> onQrScanned(String rawQrData) async {
    if (_isChecking || state.isLoading) return;

    final ticket = _extractTicket(rawQrData);
    if (ticket.isEmpty) {
      state = const EventTicketState(
        status: EventTicketStatus.error,
        validationResult: TicketValidationResult.error(
          message: 'Ticket non valido.',
        ),
      );
      return;
    }

    _isChecking = true;
    state = const EventTicketState(status: EventTicketStatus.loading);

    try {
      final result = await ref
          .read(eventTicketServiceProvider)
          .checkTicket(eventId: eventId, ticket: ticket);

      state = EventTicketState(
        status: result.isError
            ? EventTicketStatus.error
            : EventTicketStatus.success,
        ticket: ticket,
        validationResult: result,
      );
    } finally {
      _isChecking = false;
    }
  }

  String _extractTicket(String rawQrData) {
    final trimmed = rawQrData.trim();
    if (trimmed.isEmpty) return '';

    final uri = Uri.tryParse(trimmed);
    final queryTicket = uri?.queryParameters['ticket'];
    if (queryTicket != null && queryTicket.trim().isNotEmpty) {
      return queryTicket.trim();
    }

    final match = RegExp(r'(?:^|[?&])ticket=([^&]+)').firstMatch(trimmed);
    if (match != null && match.groupCount >= 1) {
      return Uri.decodeComponent(match.group(1) ?? '').trim();
    }

    return trimmed;
  }

  String _normalizeError(Object error) {
    return error
        .toString()
        .replaceAll('Exception: ', '')
        .replaceAll('Error: ', '')
        .trim();
  }
}
