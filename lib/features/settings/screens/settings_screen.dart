import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/widgets/ui.dart';
import '../../../core/providers/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import 'change_password.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _notificationsEnabled = false;

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
                    // Navigate to the new screen instead of showing a dialog
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ChangePasswordScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildSection(
              context,
              title: "Supporto",
              icon: Icons.help_outline,
              children: [
                _buildSettingsItem(
                  context,
                  title: "Centro Assistenza",
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
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
                  title: "Notifiche Push",
                  trailing: Switch.adaptive(
                    value: _notificationsEnabled,
                    onChanged: (val) =>
                        setState(() => _notificationsEnabled = val),
                  ),
                ),
                const Divider(height: 1),
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
                  onTap: () =>
                      _showTextDialog(context, "Privacy Policy", "testo"),
                ),
                _buildSettingsItem(
                  context,
                  title: "Termini e Condizioni",
                  icon: Icons.gavel_outlined,
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () =>
                      _showTextDialog(context, "Termini e Condizioni", "testo"),
                ),
                const Divider(height: 1),
                _buildSettingsItem(
                  context,
                  title: "Elimina Account",
                  titleColor: colorScheme.error,
                  icon: Icons.delete_outline,
                  iconColor: colorScheme.error,
                  onTap: () => _showDeleteAccountDialog(context, ref),
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

  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Cambia Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Password Attuale"),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Nuova Password"),
            ),
            SizedBox(height: 8),
            TextField(
              obscureText: true,
              decoration: InputDecoration(labelText: "Conferma Nuova Password"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Password cambiata con successo")),
              );
            },
            child: const Text("Salva"),
          ),
        ],
      ),
    );
  }

  void _showTextDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(child: Text(content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Chiudi"),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sei sicuro?"),
        content: const Text(
          "Questa azione è irreversibile. Tutti i tuoi dati verranno eliminati permanentemente.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annulla"),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () {
              Navigator.pop(context);
              ref
                  .read(authProvider.notifier)
                  .logout(); //TODO: usare api cancellazione account
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Account eliminato")),
              );
            },
            child: const Text("Elimina"),
          ),
        ],
      ),
    );
  }
}
