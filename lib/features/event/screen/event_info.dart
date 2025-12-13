
import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';
import 'package:greenlinkapp/features/volunteering/widgets/eventcard.dart';

class EventInfoScreen extends StatefulWidget {
  final Event e;

  const EventInfoScreen({super.key, required this.e});

  @override
  State<EventInfoScreen> createState() => _EventInfoScreenState();
}

class _EventInfoScreenState extends State<EventInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.e.eventType)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EventCard(
                event: widget.e,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
