import 'package:flutter/material.dart';
import 'package:greenlinkapp/features/volunteering/domain/volunteer.dart';
import 'package:greenlinkapp/features/volunteering/widgets/volunteercard.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/volunteering/widgets/button.dart';

class VolunteerScreen extends StatelessWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isPartner = true;
    final List<Volunteer> volunteers = [
      //hardcoded sample volunteers
      Volunteer(
        id: 1,
        owner: 'Associazione GreenHelpdsafgsdgrdsgdegrhgrafrseg',
        title: 'Raccolta RifiuRaccolta RifiuRaccolta RifiuRaccolta RifiuRaccolta Rifiuti',
        eventType: "Inquinamento",
        description:
            'Unisciti al gruppo per ripulire il lungomare dai rifiuti accumulati dopo la mareggiata.',
        date: '2024-08-02',
        startTime: '10:00',
        endTime: '13:00',
        location: 'Lungomare di Rimini',
        participantsMax: 40,
        participantsCurrent: 18,
      ),

      Volunteer(
        id: 2,
        owner: 'Protezione Civile Torino',
        title: 'Supporto Nevicate',
        eventType: "Neve",
        description:
            'Cerchiamo volontari per distribuire sale e aiutare nella rimozione neve nelle aree critiche.',
        date: '2024-12-10',
        startTime: '07:00',
        endTime: '11:00',
        location: 'Centro Storico, Torino',
        participantsMax: 25,
        participantsCurrent: 12,
      ),

      Volunteer(
        id: 3,
        owner: 'Gruppo Ambientale Veneto',
        title: 'Ripristino Sentieri Boschi',
        eventType: "Frana",
        description:
            'Aiutaci a liberare e mettere in sicurezza i sentieri colpiti da piccoli smottamenti.',
        date: '2024-09-21',
        startTime: '08:30',
        endTime: '14:00',
        location: 'Colline del Prosecco',
        participantsMax: 30,
        participantsCurrent: 9,
      ),
    ];
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Bacheca Volontariato",
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              if (isPartner)
                ButtonWidget(
                  label: 'Nuovo Evento',
                  onPressed: () {
                    // Azione per creare un nuovo evento di volontariato
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                ),
            ],
          ),

          for (final v in volunteers)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: UiCard(
                child: VolunteerCard(
                  volunteer: v,
                  onTap: () {
                    // Navigo in PostInfoScreen con i dettagli del post selezionato
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}
