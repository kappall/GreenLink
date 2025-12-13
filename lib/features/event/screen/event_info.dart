
import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/feed/widgets/button.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';

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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ButtonWidget(
                    label: "${widget.e.participantsCurrent}/${widget.e.participantsMax} Partecipanti",
                    onPressed: () {
                      setState(() {
                      
                      });
                    },
                    icon: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    "",
                  ),
                ],
              ),

              // comments section
              const SizedBox(height: 8),
              TextField(
                controller: TextEditingController(),
                decoration: InputDecoration(
                  hintText: 'Scrivi un commento...',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
