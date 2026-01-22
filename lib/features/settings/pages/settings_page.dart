import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/features/legal/pages/privacy_policy_page.dart';
import 'package:greenlinkapp/features/legal/pages/terms_and_conditions_page.dart';
import 'package:greenlinkapp/features/settings/pages/change_location_page.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../core/utils/feedback_utils.dart';
import '../../auth/providers/auth_provider.dart';
import '../../event/providers/event_provider.dart';
import '../../feed/providers/comment_provider.dart';
import '../../feed/providers/post_provider.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _isDeletingAccount = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Impostazioni",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSection(
              context,
              title: "Sicurezza",
              icon: Icons.lock_outline,
              children: [
                _buildSettingsItem(
                  context,
                  title: "Cambia Password",
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    context.push('/change-password');
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              context,
              title: "Impostazioni Applicazione",
              icon: Icons.settings_outlined,
              children: [
                _buildSettingsItem(
                  context,
                  title: "Cambia Posizione",
                  icon: Icons.location_on_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangeLocationPage(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              context,
              title: "Privacy e Sicurezza",
              icon: Icons.shield_outlined,
              children: [
                _buildSettingsItem(
                  context,
                  title: "Privacy Policy",
                  icon: Icons.description_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage(),
                      ),
                    );
                  },
                ),
                _buildSettingsItem(
                  context,
                  title: "Termini e Condizioni",
                  icon: Icons.gavel_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const TermsAndConditionsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: "Esporta Dati",
                  icon: Icons.download_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => _exportUserData(context, ref),
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: "Elimina Account",
                  titleColor: colorScheme.error,
                  icon: Icons.delete_outline,
                  iconColor: colorScheme.error,
                  onTap: _isDeletingAccount
                      ? null
                      : () => _showDeleteAccountDialog(context, ref),
                ),
              ],
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  side: BorderSide(color: Colors.grey.shade300),
                ),
                onPressed: () {
                  ref.read(authProvider.notifier).logout();
                },
                icon: const Icon(Icons.logout, size: 20),
                label: const Text("Logout"),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return UiCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsItem(
    BuildContext context, {
    required String title,
    Color? titleColor,
    IconData? icon,
    Color? iconColor,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20, color: iconColor ?? Colors.grey[700]),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: titleColor ?? Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text("Sei sicuro?"),
        content: const Text(
          "Questa azione è irreversibile. Tutti i tuoi dati verranno eliminati permanentemente.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text("Annulla"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: _isDeletingAccount
                ? null
                : () async {
                    if (_isDeletingAccount) return;
                    setState(() => _isDeletingAccount = true);
                    Navigator.pop(dialogContext);

                    try {
                      await ref.read(authProvider.notifier).deleteAccount();
                      if (!mounted) return;
                      FeedbackUtils.showSuccess(
                        context,
                        "Account eliminato con successo",
                      );
                    } catch (error) {
                      if (!mounted) return;
                      FeedbackUtils.showError(
                        context,
                        "Errore durante l'eliminazione dell'account: $error",
                      );
                    } finally {
                      if (mounted) {
                        setState(() => _isDeletingAccount = false);
                      }
                    }
                  },
            child: const Text("Elimina"),
          ),
        ],
      ),
    );
  }

  void _exportUserData(BuildContext context, WidgetRef ref) async {
    final user = ref.read(authProvider).asData?.value.user;

    if (user == null) {
      FeedbackUtils.showError(context, "Utente non autenticato.");
      return;
    }
    final userPosts = ref.read(postsProvider(user.id)).asData?.value;
    final userEvents = ref.read(eventsByUserProvider(user.id)).asData?.value;
    final userComments = ref
        .read(commentsByUserIdProvider(user.id))
        .asData
        ?.value;

    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build: (pw.Context context) => [
          pw.Text(
            'Dati Utente',
            style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
          ),
          pw.Divider(),
          pw.SizedBox(height: 20),
          pw.Text('ID: ${user.id}'),
          pw.Text('Email: ${user.email}'),
          pw.Text('Username: ${user.username ?? 'Sconosciuto'}'),
          pw.Text('Ruolo: ${user.role?.name ?? 'Sconosciuto'}'),
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),
          if (userPosts != null) ...[
            pw.Text(
              "Post pubblicati (non eliminati)",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.ListView.builder(
              itemBuilder: (context, index) {
                final post = userPosts.items[index];
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Post id: ${post.id}"),
                    pw.Text("Descrizione: ${post.description}"),
                    pw.Text("Numero media: ${post.media.length}"),
                    pw.Text("Creato in data: ${post.createdAt}"),
                    pw.Divider(),
                  ],
                );
              },
              itemCount: userPosts.totalItems,
            ),
          ],
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),
          if (userEvents != null) ...[
            pw.Text(
              "Eventi partecipati (non eliminati)",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.ListView.builder(
              itemBuilder: (context, index) {
                final event = userEvents.items[index];
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Event id: ${event.id}"),
                    pw.Text("titolo: ${event.title}"),
                    pw.Text("Descrizione: ${event.description}"),
                    pw.Divider(),
                  ],
                );
              },
              itemCount: userEvents.totalItems,
            ),
          ],
          pw.SizedBox(height: 20),
          pw.Divider(),
          pw.SizedBox(height: 20),
          if (userComments != null) ...[
            pw.Text(
              "Commenti pubblicati (non eliminati)",
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
            pw.ListView.builder(
              itemBuilder: (context, index) {
                final comment = userComments[index];
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text("Commento id: ${comment.id}"),
                    pw.Text("Post id: ${comment.contentId}"),
                    pw.Text("Descrizione: ${comment.description}"),
                    pw.Text("Creato in data: ${comment.createdAt}"),
                    pw.Divider(),
                  ],
                );
              },
              itemCount: userComments.length,
            ),
          ],
        ],
      ),
    );

    try {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/user_data.pdf');
      await file.writeAsBytes(await pdf.save());

      OpenFile.open(file.path);
    } catch (e) {
      FeedbackUtils.showError(context, "Impossibile esportare i dati: $e");
    }
  }
}
