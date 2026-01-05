import 'package:flutter/material.dart';

import 'legal_document_page.dart';

class TermsAndConditionsPage extends StatelessWidget {
  const TermsAndConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentPage(
      title: "Termini e Condizioni",
      url: "https://greenlink.tommasodeste.it/terms-conditions.html",
    );
  }
}
