import 'package:flutter/material.dart';

class EmptyUsersState extends StatelessWidget {
  final bool isSearching;
  final String? query;
  final VoidCallback? onClearSearch;

  const EmptyUsersState({
    super.key,
    required this.isSearching,
    this.query,
    this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isSearching ? Icons.person_search_outlined : Icons.people_outline,
              size: 64,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 16),
            Text(
              isSearching
                  ? "Nessun risultato trovato"
                  : "Nessun utente disponibile",
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              isSearching && query != null
                  ? "La ricerca \"$query\" non ha prodotto risultati."
                  : "Gli utenti appariranno qui non appena disponibili.",
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            if (isSearching && onClearSearch != null) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: onClearSearch,
                icon: const Icon(Icons.clear),
                label: const Text("Cancella ricerca"),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
