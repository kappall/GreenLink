import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';
import 'package:greenlinkapp/core/providers/theme_provider.dart';
import 'package:greenlinkapp/features/legal/pages/legal_document_page.dart';

import '../../../core/utils/feedback_utils.dart';
import '../../auth/providers/auth_provider.dart';
import 'change_password.dart';

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

    final currentThemeMode = ref.watch(themeProvider);

    final isDark = currentThemeMode == ThemeMode.dark;

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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordPage(),
                      ),
                    );
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
                  title: "Tema Scuro",
                  trailing: Switch.adaptive(
                    value: isDark,
                    onChanged: (val) {
                      ref
                          .read(themeProvider.notifier)
                          .setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
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
                  onTap: () => _openLegal(
                    "Privacy Policy",
                    "https://greenlink.tommasodeste.it/privacy-policy.html",
                  ),
                ),
                _buildSettingsItem(
                  context,
                  title: "Termini e Condizioni",
                  icon: Icons.gavel_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () => _openLegal(
                    "Termini e Condizioni",
                    "https://greenlink.tommasodeste.it/terms-conditions.html",
                  ),
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

  void _openLegal(String title, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LegalDocumentPage(title: title, url: url),
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
}
