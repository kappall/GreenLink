import 'package:flutter/material.dart';
import 'package:greenlinkapp/core/common/widgets/bottomnavigation.dart';
import 'package:greenlinkapp/core/common/widgets/carousel.dart';
import 'package:greenlinkapp/core/common/widgets/alert.dart';
import 'package:greenlinkapp/core/common/widgets/badge.dart';
import 'package:greenlinkapp/core/common/widgets/card.dart';


class UiShowcaseScreen extends StatelessWidget {
  const UiShowcaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final carouselItems = _buildCarouselItems(theme);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UI Components'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Esempi rapidi dei componenti condivisi in ui.dart.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 20),

            const _SectionTitle('Badge'),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: const [
                UiBadge(label: 'Successo'),  //BADGE
                UiBadge(label: 'Con icona', icon: Icons.star_rounded),
                UiBadge(
                  label: 'Outline',
                  icon: Icons.eco_outlined,
                  isOutline: true,
                ),
                UiBadge(
                  label: 'Info',
                  color: Color(0xFF2563EB),
                  icon: Icons.info_outline,
                ),
              ],
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Alert'),
            const UiAlert(
              title: 'Informazione',
              description: 'Questo è un alert informativo con un testo più lungo.',
              icon: Icons.info_outline,
            ),
            const SizedBox(height: 12),
            const UiAlert(
              title: 'Attenzione',
              description: 'Versione evidenziata con un colore diverso.',
              icon: Icons.warning_amber_rounded,
              color: Color(0xFFB45309),
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Card'),
            UiCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card con titolo',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Usa UiCard per raggruppare contenuti. Qui puoi inserire testi, bottoni o qualsiasi widget.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: const [
                      UiBadge(label: 'Tag'),
                      SizedBox(width: 8),
                      UiBadge(
                        label: 'Secondario',
                        color: Color(0xFF2563EB),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Carousel'),
            UiCard(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Swipe laterale per vedere le card.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: 8),
                  UiCarousel(items: carouselItems, height: 180),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const _SectionTitle('Bottom Navigation'),
            UiCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Anteprima della navigation bar personalizzata.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  const Divider(height: 1),
                  const UiBottomNavigation(
                    currentIndex: 1,
                    showAdmin: true,
                    onTap: null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildCarouselItems(ThemeData theme) {
    final colors = [
      theme.colorScheme.primary,
      theme.colorScheme.secondary,
      const Color(0xFFF97316),
    ];

    return colors
        .asMap()
        .entries
        .map(
          (entry) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: UiCard(
              padding: EdgeInsets.zero,
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      entry.value.withValues(alpha: 0.8),
                      entry.value.withValues(alpha: 0.4),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Slide ${entry.key + 1}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
