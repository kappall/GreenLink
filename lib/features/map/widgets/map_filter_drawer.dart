import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/map/provider/map_provider.dart';

class MapFilterDrawer extends ConsumerWidget {
  final double width;
  final double height;
  final double tongueWidth;

  const MapFilterDrawer({
    this.width = 260,
    this.height = 160,
    this.tongueWidth = 36,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOpen = ref.watch(mapFilterPanelProvider);
    final filter = ref.watch(mapFilterStateProvider);

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        alignment: Alignment.centerRight,
        children: [
          // Animated sliding panel (behind the tongue)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            right: isOpen ? 0 : -(width - tongueWidth),
            top: 0,
            bottom: 0,
            child: ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Material(
                elevation: 6,
                color: Colors.white.withOpacity(0.95),
                child: SizedBox(
                  width: width,
                  child: Padding(
                    padding: EdgeInsets.only(left: tongueWidth + 8, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Segnalazioni'),
                          value: filter.showPosts,
                          onChanged: (_) => ref
                              .read(mapFilterStateProvider.notifier)
                              .togglePosts(),
                        ),
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Eventi'),
                          value: filter.showEvents,
                          onChanged: (_) => ref
                              .read(mapFilterStateProvider.notifier)
                              .toggleEvents(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Tongue
          Positioned(
            right: 0,
            child: GestureDetector(
              onTap: () => ref.read(mapFilterPanelProvider.notifier).toggle(),
              child: Container(
                width: tongueWidth,
                height: height,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.95),
                  borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(16),
                  ),
                  boxShadow: const [
                    BoxShadow(blurRadius: 6, color: Colors.black26),
                  ],
                ),
                child: Icon(
                  isOpen ? Icons.chevron_right : Icons.tune,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
