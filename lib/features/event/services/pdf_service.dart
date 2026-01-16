import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/event/models/event_model.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/providers/geocoding_provider.dart';

class PdfService {
  final Ref _ref;

  PdfService(this._ref);

  Future<File> createTicket(
    EventModel event,
    String ticketId,
    String ticket,
    String userName,
  ) async {
    final pdf = pw.Document();

    final geoKey = (lat: event.latitude, lng: event.longitude);
    final String locationName = await _ref.read(
      placeNameProvider(geoKey).future,
    );

    final ByteData logoData = await rootBundle.load('assets/GreenLinkLogo.png');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final pw.ImageProvider logoImage = pw.MemoryImage(logoBytes);

    final baseStyle = pw.TextStyle(color: PdfColors.grey800, fontSize: 10);
    final boldStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 11,
    );
    final titleStyle = pw.TextStyle(
      fontWeight: pw.FontWeight.bold,
      fontSize: 20,
      color: PdfColors.green800,
    );

    const PdfPageFormat pageFormat = PdfPageFormat.a6;

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.center,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.green400, width: 1.5),
              borderRadius: pw.BorderRadius.circular(8),
            ),
            padding: const pw.EdgeInsets.all(16),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      "BIGLIETTO D'INGRESSO",
                      style: pw.TextStyle(
                        color: PdfColors.grey600,
                        fontStyle: pw.FontStyle.italic,
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(
                      height: 35,
                      width: 35,
                      child: pw.Image(logoImage),
                    ),
                  ],
                ),
                pw.Divider(color: PdfColors.grey300, height: 15),

                pw.Text(event.title, style: titleStyle),
                pw.SizedBox(height: 15),
                _buildDetailRow(
                  "Data",
                  DateFormat(
                    'EEEE, d MMMM yyyy',
                    'it_IT',
                  ).format(event.startDate),
                  boldStyle,
                  baseStyle,
                ),
                _buildDetailRow(
                  "Ora",
                  DateFormat('HH:mm').format(event.startDate),
                  boldStyle,
                  baseStyle,
                ),
                _buildDetailRow("Luogo", locationName, boldStyle, baseStyle),
                pw.SizedBox(height: 20),

                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      "Partecipante",
                      userName,
                      boldStyle,
                      baseStyle,
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text(
                      "Presenta questo QR code all'ingresso.",
                      style: pw.TextStyle(
                        color: PdfColors.grey600,
                        fontSize: 8,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.center,
                      children: [
                        pw.SizedBox(
                          height: 85,
                          width: 85,
                          child: pw.BarcodeWidget(
                            barcode: pw.Barcode.qrCode(),
                            data: ticket,
                            color: PdfColors.black,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.Divider(color: PdfColors.grey300),
                pw.SizedBox(height: 5),
                pw.Text(
                  "Questo biglietto è personale, non cedibile e non rimborsabile. Generato tramite GreenLink.",
                  style: pw.TextStyle(fontSize: 7, color: PdfColors.grey500),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    final output = await getApplicationDocumentsDirectory();
    final file = File(
      "${output.path}/ticket_${event.id}_${ticketId.substring(0, 8)}.pdf",
    );
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  pw.Widget _buildDetailRow(
    String title,
    String value,
    pw.TextStyle titleStyle,
    pw.TextStyle valueStyle,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 3),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(width: 75, child: pw.Text(title, style: titleStyle)),
          pw.Expanded(child: pw.Text(value, style: valueStyle)),
        ],
      ),
    );
  }

  Future<void> openPdf(File file) async {
    await OpenFile.open(file.path);
  }
}

final pdfServiceProvider = Provider<PdfService>((ref) {
  return PdfService(ref);
});
