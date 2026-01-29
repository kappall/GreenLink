import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/event/services/pdf_service.dart';
import 'package:greenlinkapp/features/map/pages/map.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../core/common/widgets/badge.dart';
import '../../../core/providers/geocoding_provider.dart';
import '../../../core/utils/feedback_utils.dart';

class EventInfoPage extends ConsumerStatefulWidget {
  EventModel event;
  EventInfoPage({super.key, required this.event});

  @override
  ConsumerState<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends ConsumerState<EventInfoPage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final theme = Theme.of(context);
    final auth = ref.watch(authProvider).value;
    final isAdmin = auth?.isAdmin ?? false;
    final isAuthor = auth?.user?.id == event.author.id;

    final participantsAsync = ref.watch(eventParticipantsProvider(event.id!));

    final startDate = DateFormat.yMMMd().add_jm().format(event.startDate);
    final endDate = DateFormat.yMMMd().add_jm().format(event.endDate);
    final today = DateTime.now();
    final bool isToday =
        event.startDate.year == today.year &&
        event.startDate.month == today.month &&
        event.startDate.day == today.day;

    final geoKey = (lat: event.latitude, lng: event.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${event.latitude}, ${event.longitude}";

    final isExpired = DateTime.now().isAfter(event.endDate);
    final isActionDisabled = isExpired || isAuthor;
    final bool isParticipating = event.isParticipating;
    final bool showQrAction = isParticipating && !isActionDisabled;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dettaglio Evento"),
        actions: [
          if (isAdmin || isAuthor)
            IconButton(
              icon: _isDeleting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: _isDeleting ? null : () => _confirmDelete(context),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isAuthor
                                  ? "Organizzato da te"
                                  : "Organizzato da ${event.author.displayName}",
                              style: TextStyle(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          if (isAuthor)
                            const UiBadge(
                              label: "Creato da te",
                              color: Colors.orange,
                              icon: Icons.star,
                            ),
                          const UiBadge(
                            label: "Evento",
                            color: Colors.blue,
                            icon: Icons.event,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Descrizione",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    event.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  _buildInfoRow(Icons.calendar_today, "Inizio", startDate),
                  const SizedBox(height: 12),
                  _buildInfoRow(Icons.calendar_today, "Fine", endDate),
                  const SizedBox(height: 12),
                  if (event.maxParticipants != null)
                    _buildInfoRow(
                      Icons.people_outline,
                      "Partecipanti",
                      "${event.participantsCount} / ${event.maxParticipants}",
                    ),
                  if (event.maxParticipants == null)
                    _buildInfoRow(
                      Icons.people_outline,
                      "Partecipanti",
                      "${event.participantsCount}",
                    ),
                  const SizedBox(height: 12),
                  const Text(
                    "Posizione",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: isAdmin
                        ? null
                        : () {
                            context.go(
                              '/map',
                              extra: MapTargetLocation(
                                latitude: event.latitude,
                                longitude: event.longitude,
                                zoom: 15,
                                event: event,
                              ),
                            );
                          },
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              locationName,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          if (!isAdmin)
                            const Icon(Icons.chevron_right, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),
                  if (isAuthor) ...[
                    const SizedBox(height: 24),
                    const Text(
                      "Partecipanti",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (event.id == null)
                      Text(
                        "L'evento deve avere un ID valido per mostrare i partecipanti.",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      )
                    else
                      participantsAsync.when(
                        data: (participants) => participants.isEmpty
                            ? const Text("Non ci sono ancora partecipanti.")
                            : Column(
                                children: [
                                  for (final user in participants)
                                    _buildParticipantTile(user),
                                ],
                              ),
                        loading: () => const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
                          child: Center(child: CircularProgressIndicator()),
                        ),
                        error: (error, _) => Text(
                          "Errore nel caricamento dei partecipanti",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
          ),
          if (!isAdmin) ...[
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: (isAuthor && isToday)
                        ? ElevatedButton.icon(
                            onPressed: () {
                              final eventId = event.id?.toString();
                              if (eventId != null) {
                                context.push('/event/$eventId/scanner');
                              }
                            },
                            icon: const Icon(Icons.qr_code_scanner),
                            label: const Text('Valida Biglietti'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.primary,
                              foregroundColor: Theme.of(
                                context,
                              ).colorScheme.onPrimary,
                            ),
                          )
                        : FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: isActionDisabled
                                  ? Colors.grey[400]
                                  : Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: isActionDisabled
                                ? null
                                : (isParticipating
                                      ? () => _requestQrCode(context, ref)
                                      : () => _participateEvent(context, ref)),
                            child: Text(
                              isExpired
                                  ? "EVENTO SCADUTO"
                                  : isAuthor
                                  ? "HAI CREATO QUESTO EVENTO"
                                  : isParticipating
                                  ? "OTTIENI QR CODE"
                                  : "PARTECIPA ALL'EVENTO",
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                  ),
                  if (showQrAction) ...[
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        onPressed: () => _leaveEvent(context, ref),
                        child: const Text("DISISCRIVITI"),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _participateEvent(BuildContext context, WidgetRef ref) async {
    try {
      final eventId = widget.event.id;
      if (eventId == null) {
        FeedbackUtils.showError(context, 'Evento non valido.');
        return;
      }
      final ticket = await ref
          .read(eventsProvider(null).notifier)
          .participate(eventId: eventId);
      if (!mounted) return;
      final newEvent = await ref
          .read(eventsProvider(null).notifier)
          .fetchEvent(eventId);
      if (newEvent == null) {
        FeedbackUtils.logInfo("null");
        context.pop();
      } else {
        setState(() {
          widget.event = newEvent;
        });
      }
      await _showQrCode(context, ticket);
      if (!mounted) return;
      FeedbackUtils.showSuccess(context, "Partecipi all'evento");
    } catch (e) {
      FeedbackUtils.showError(context, e);
    }
  }

  Future<void> _requestQrCode(BuildContext context, WidgetRef ref) async {
    try {
      final eventId = widget.event.id;
      if (eventId == null) {
        FeedbackUtils.showError(context, 'Evento non valido.');
        return;
      }
      final ticket = await ref
          .read(eventsProvider(null).notifier)
          .participate(eventId: eventId);
      await _showQrCode(context, ticket);
    } catch (e) {
      FeedbackUtils.showError(context, e);
    }
  }

  Future<void> _leaveEvent(BuildContext context, WidgetRef ref) async {
    try {
      final eventId = widget.event.id;
      if (eventId == null) {
        FeedbackUtils.showError(context, 'Evento non valido.');
        return;
      }
      await ref
          .read(eventsProvider(null).notifier)
          .cancelParticipation(eventId: eventId);
      if (!mounted) return;
      final newEvent = await ref
          .read(eventsProvider(null).notifier)
          .fetchEvent(eventId);
      if (newEvent == null) {
        FeedbackUtils.logInfo("null");
        context.pop();
      } else {
        setState(() {
          widget.event = newEvent;
        });
      }
      FeedbackUtils.showSuccess(context, "Hai annullato la partecipazione");
    } catch (e) {
      FeedbackUtils.showError(context, e);
    }
  }

  Future<void> _showQrCode(BuildContext context, String ticket) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('QR code evento'),
        content: SizedBox(
          width: 260,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: ticket,
                size: 220,
                backgroundColor: Colors.white,
              ),
              const SizedBox(height: 12),
              const Text(
                'Mostra questo QR al partner per la validazione.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              try {
                final auth = ref.watch(authProvider).value;
                final pdfService = ref.read(pdfServiceProvider);

                final ticketId =
                    "${DateTime.now().toLocal()}-${widget.event.id!}";

                final File ticketFile = await pdfService.createTicket(
                  widget.event,
                  ticketId,
                  ticket,
                  auth?.user?.displayName ?? '',
                );

                await pdfService.openPdf(ticketFile);
              } catch (e) {
                FeedbackUtils.logError("Error creating pdf: $e");
              }
            },
            child: const Text('Download'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Elimina Evento"),
        content: const Text("Sei sicuro di voler eliminare questo evento?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Annulla"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Elimina", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isDeleting = true);
      try {
        await ref
            .read(eventsProvider(null).notifier)
            .deleteEvent(widget.event.id!);
        if (mounted) {
          Navigator.pop(context);
        }
        FeedbackUtils.showSuccess(context, "Evento eliminato con successo");
      } catch (e) {
        if (mounted) {
          FeedbackUtils.showError(context, e);
        }
      } finally {
        if (mounted) {
          setState(() => _isDeleting = false);
        }
      }
    }
  }

  Widget _buildParticipantTile(UserModel user) {
    final hasEmail =
        user.email.isNotEmpty && user.email != 'default@example.com';
    final subtitle = hasEmail
        ? user.email
        : (user.role != null ? user.role!.name : '');
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: const Icon(Icons.person_outline),
        title: Text(user.displayName),
        subtitle: subtitle.isEmpty ? null : Text(subtitle),
        trailing: user.isBlocked
            ? const Icon(Icons.block, color: Colors.red)
            : null,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Colors.grey[500]),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
