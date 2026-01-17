import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/controllers/event_ticket_controller.dart';
import 'package:greenlinkapp/features/event/models/ticket_validation_result.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class EventQrScannerPage extends ConsumerStatefulWidget {
  final String eventId;

  const EventQrScannerPage({super.key, required this.eventId});

  @override
  ConsumerState<EventQrScannerPage> createState() => _EventQrScannerPageState();
}

class _EventQrScannerPageState extends ConsumerState<EventQrScannerPage> {
  final MobileScannerController _cameraController = MobileScannerController();

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ref.read(
      eventTicketControllerProvider(widget.eventId).notifier,
    );
    final state = ref.watch(eventTicketControllerProvider(widget.eventId));

    ref.listen<EventTicketState>(
      eventTicketControllerProvider(widget.eventId),
      (_, next) async {
        if (next.status == EventTicketStatus.success ||
            next.status == EventTicketStatus.error) {
          if (next.validationResult == null) return;

          final result = await showDialog<String>(
            context: context,
            barrierDismissible: false,
            builder: (context) =>
                ValidationResultDialog(result: next.validationResult!),
          );

          if (result == 'retry' || result == 'scan_again') {
            await _cameraController.start();
          } else if (result == 'close') {
            if (mounted) Navigator.of(context).pop();
          }
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Inquadra il QR del Biglietto')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _cameraController,
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && !state.isLoading) {
                _cameraController.stop();
                final String rawQrData = barcodes.first.rawValue ?? '';
                controller.onQrScanned(rawQrData);
              }
            },
          ),
          Center(
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          if (state.isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}

class ValidationResultDialog extends StatelessWidget {
  final TicketValidationResult result;

  const ValidationResultDialog({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return result.map(
      valid: (value) => _buildDialog(
        context,
        title: 'Biglietto Valido',
        icon: Icons.check_circle,
        color: Colors.green,
        content: Text(result.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('scan_again'),
            child: const Text('Scansiona Ancora'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('close'),
            child: const Text('Chiudi'),
          ),
        ],
      ),
      wrongEvent: (value) => _buildDialog(
        context,
        title: 'Evento Errato',
        icon: Icons.error,
        color: Colors.red,
        content: Text(result.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('scan_again'),
            child: const Text('Scansiona Ancora'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('close'),
            child: const Text('Chiudi'),
          ),
        ],
      ),
      error: (value) => _buildDialog(
        context,
        title: 'Errore',
        icon: Icons.error,
        color: Colors.red,
        content: Text(result.message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('retry'),
            child: const Text('Riprova'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('close'),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  AlertDialog _buildDialog(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget content,
    required List<Widget> actions,
  }) {
    return AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: content,
      actions: actions,
    );
  }
}
