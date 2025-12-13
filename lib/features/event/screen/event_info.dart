import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/features/event/widgets/detailrow.dart';
import 'package:greenlinkapp/features/event/widgets/infocard.dart';

class EventInfoScreen extends StatefulWidget {
  final Event e;

  const EventInfoScreen({super.key, required this.e});

  @override
  State<EventInfoScreen> createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  bool isJoined = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.e.eventType)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title Section
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.e.title,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      UiBadge(
                        label: widget.e.eventType,
                        icon: Icons.eco,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: colorScheme.primaryContainer,
                        child: Text(
                          widget.e.owner.isNotEmpty
                              ? widget.e.owner[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 18,
                            color: colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Organizzato da',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              widget.e.owner,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.flag_outlined,
                          color: Colors.grey[600],
                        ),
                        onPressed: () {
                          // Report event
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Expanded(
                    child: InfoCard(
                      icon: Icons.group,
                      title: 'Partecipanti',
                      value:
                          '${widget.e.participantsCurrent}/${widget.e.participantsMax}',
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InfoCard(
                      icon: Icons.calendar_today,
                      title: 'Data',
                      value: widget.e.date,
                      color: colorScheme.secondary,
                    ),
                  ),
                ],
              ),
            ),

            // Date & Time Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Card(
                elevation: 0,
                color: Colors.grey[100],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      DetailRow(
                        icon: Icons.access_time,
                        title: 'Orario',
                        value: '${widget.e.startTime} - ${widget.e.endTime}',
                        iconColor: colorScheme.tertiary,
                      ),
                      const SizedBox(height: 12),
                      DetailRow(
                        icon: Icons.location_on,
                        title: 'Luogo',
                        value: widget.e.location,
                        iconColor: colorScheme.error,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Description Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Descrizione',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    widget.e.description,
                    style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Location with directions button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Posizione',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Open map
                    },
                    icon: const Icon(Icons.directions),
                    label: const Text('Ottieni indicazioni'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom spacing for FAB
            const SizedBox(height: 120),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: FloatingActionButton.extended(
            elevation: 4,
            onPressed: () {
              setState(() {
                isJoined = !isJoined;
              });
            },
            icon: Icon(
              isJoined ? Icons.check_circle : Icons.volunteer_activism,
            ),
            label: Text(
              isJoined ? 'Iscritto' : 'Partecipa',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            backgroundColor: isJoined ? Colors.grey[600] : colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
