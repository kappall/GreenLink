import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:greenlinkapp/features/event/providers/event_provider.dart';
import 'package:greenlinkapp/features/user/models/user_model.dart';
import 'package:greenlinkapp/features/user/providers/user_provider.dart';
import 'package:intl/intl.dart';

import '../../../core/common/widgets/badge.dart';
import '../../../core/providers/geocoding_provider.dart';
import '../../../core/utils/feedback_utils.dart';
import '../../auth/providers/auth_provider.dart';

class EventInfoPage extends ConsumerStatefulWidget {
  final EventModel event;

  const EventInfoPage({super.key, required this.event});

  @override
  ConsumerState<EventInfoPage> createState() => _EventInfoPageState();
}

class _EventInfoPageState extends ConsumerState<EventInfoPage> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final startDate = DateFormat('dd MMM yyyy, HH:mm').format(event.startDate);
    final endDate = DateFormat('dd MMM yyyy, HH:mm').format(event.endDate);

    final geoKey = (lat: event.latitude, lng: event.longitude);
    final locationAsync = ref.watch(placeNameProvider(geoKey));
    final locationName =
        locationAsync.value ?? "${event.latitude}, ${event.longitude}";

    final authState = ref.watch(authProvider);
    final isAdmin = authState.asData?.value.isAdmin ?? false;
    final currentUser = ref.watch(currentUserProvider).value;
    final isAuthor = currentUser?.id == event.author.id;
    final participantsAsync = (isAuthor && event.id != null)
      ? ref.watch(eventParticipantsProvider(event.id!))
      : const AsyncData<List<UserModel>>([]);

    final bool isExpired = event.startDate.isBefore(DateTime.now());

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
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    "Posizione",
                    locationName,
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor:
                      (event.isParticipating || isExpired || isAuthor)
                      ? Colors.grey[400]
                      : Theme.of(context).colorScheme.primary,
                ),
                onPressed: (event.isParticipating || isExpired || isAuthor)
                    ? null
                    : () => _participateEvent(context, ref),
                child: Text(
                  isExpired
                      ? "EVENTO SCADUTO"
                      : isAuthor
                      ? "HAI CREATO QUESTO EVENTO"
                      : event.isParticipating
                      ? "SEI ISCRITTO"
                      : "PARTECIPA ALL'EVENTO",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _participateEvent(BuildContext context, WidgetRef ref) async {
    try {
      await ref
          .read(eventsProvider(null).notifier)
          .participate(eventId: widget.event.id!);
      context.pop();
      FeedbackUtils.showSuccess(context, "Partecipi all'evento");
    } catch (e) {
      FeedbackUtils.showError(context, e);
    }
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
        // TODO: implement delete call in provider/service
        // await ref.read(eventsProvider.notifier).deleteEvent(widget.event.id!);
        if (mounted) {
          Navigator.pop(context);
        }
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
    final hasEmail = user.email.isNotEmpty && user.email != 'default@example.com';
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
