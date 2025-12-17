import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/event/widgets/button.dart';
import 'package:greenlinkapp/features/event/widgets/eventcard.dart';
import 'package:greenlinkapp/features/volunteering/domain/event.dart';

class VolunteeringPage extends StatelessWidget {
  const VolunteeringPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isPartner = true; // Simulazione del controllo del ruolo partner
    final List<Event> events = [
      //hardcoded sample events
      Event(
        id: 1,
        owner: 'Associazione GreenHelp',
        title: 'Raccolta Rifiuti',
        eventType: "Inquinamento",
        description:
            'Unisciti al gruppo per ripulire il lungomare dai rifiuti accumulati dopo la recente mareggiata. La tempesta ha portato a riva una grande quantità di plastica, reti da pesca, e altri materiali inquinanti che minacciano l\'ecosistema marino locale. I volontari saranno dotati di guanti, sacchi e attrezzatura di sicurezza. L\'obiettivo è raccogliere e classificare i rifiuti per un corretto smaltimento e riciclo. Questa è un\'ottima opportunità per contribuire attivamente alla salvaguardia dell\'ambiente costiero e sensibilizzare la comunità sull\'importanza della riduzione dell\'inquinamento marino.',
        date: '2024-08-02',
        startTime: '10:00',
        endTime: '13:00',
        location: 'Lungomare di Rimini',
        participantsMax: 40,
        participantsCurrent: 18,
      ),

      Event(
        id: 2,
        owner: 'Protezione Civile Torino',
        title: 'Supporto Nevicate',
        eventType: "Neve",
        description:
            'Cerchiamo volontari per aiutare la comunità durante l\'emergenza neve. Le attività includono la distribuzione di sale antigelo nelle zone residenziali, l\'assistenza agli anziani per la rimozione della neve dai marciapiedi, e il supporto logistico ai servizi di emergenza. È previsto un briefing iniziale sulla sicurezza e verranno forniti tutti gli strumenti necessari. I volontari lavoreranno in squadre coordinate dalla Protezione Civile per garantire che le aree più critiche della città siano accessibili e sicure. Un piccolo rinfresco caldo sarà offerto durante la pausa. La tua partecipazione può fare la differenza per chi ha bisogno di aiuto.',
        date: '2024-12-10',
        startTime: '07:00',
        endTime: '11:00',
        location: 'Centro Storico, Torino',
        participantsMax: 25,
        participantsCurrent: 12,
      ),

      Event(
        id: 3,
        owner: 'Gruppo Ambientale Veneto',
        title: 'Ripristino Sentieri Boschi',
        eventType: "Frana",
        description:
            'Aiutaci a ripristinare i sentieri boschivi delle Colline del Prosecco danneggiati da recenti smottamenti e frane minori. Il lavoro prevede la rimozione di detriti, il consolidamento dei percorsi con materiali naturali, e la segnalazione delle aree pericolose. Saranno presenti esperti di geologia che ci guideranno nelle operazioni di messa in sicurezza. I volontari riceveranno una formazione base sulle tecniche di ripristino sentieristico e sull\'identificazione dei rischi geologici. Questa iniziativa è fondamentale per preservare la rete escursionistica locale e proteggere la biodiversità del territorio. Al termine dell\'attività, ci sarà un momento conviviale con prodotti locali per ringraziare tutti i partecipanti.',
        date: '2024-09-21',
        startTime: '08:30',
        endTime: '14:00',
        location: 'Colline del Prosecco',
        participantsMax: 30,
        participantsCurrent: 9,
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          decoration: InputDecoration(
            hintText: 'Cerca eventi di volontariato...',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),

        const SizedBox(height: 16),

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

        const SizedBox(height: 8),

        for (final e in events)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: UiCard(
              child: EventCard(
                event: e,
                onTap: () => context.push('/event-info', extra: e),
              ),
            ),
          ),
      ],
    );
  }
}
