import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/auth/utils/role_parser.dart';

import '../../../core/services/socket_service.dart';
import '../providers/onboarding_provider.dart';
import 'location_onboarding_page.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _userPages = [
    const OnboardingContent(
      title: "Benvenuto su GreenLink!",
      description:
          "La tua community per un mondo più pulito, sostenibile e sicuro.",
      icon: Icons.eco,
      color: Colors.green,
    ),
    const OnboardingContent(
      title: "Segnala Criticità",
      description:
          "Incendi, guasti elettrici o danni ambientali? Scatta una foto e caricala per avvisare subito la community e chi di dovere.",
      icon: Icons.report_problem_outlined,
      color: Colors.redAccent,
    ),
    const OnboardingContent(
      title: "Esplora il Territorio",
      description:
          "Usa la mappa interattiva per restare informato su ciò che accade intorno a te in tempo reale.",
      icon: Icons.map_outlined,
      color: Colors.blue,
    ),
    const OnboardingContent(
      title: "Eventi di Volontariato",
      description:
          "Mettiti in gioco! Partecipa alle iniziative di volontariato organizzate dai nostri partner per la cura dell'ambiente.",
      icon: Icons.groups_outlined,
      color: Colors.orange,
    ),
  ];

  final OnboardingContent _partnerPage = const OnboardingContent(
    title: "Sei un Partner!",
    description:
        "Come partner ufficiale, hai gli strumenti per creare eventi e guidare la community verso azioni concrete.",
    icon: Icons.verified_user_outlined,
    color: Colors.teal,
  );

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final role = ref.watch(
      authProvider.select((auth) => auth.value?.role ?? AuthRole.user),
    );
    final isPartner = role == AuthRole.partner;
    final infoPages = isPartner ? [..._userPages, _partnerPage] : _userPages;

    final totalPages = infoPages.length + 1;
    final isLastPage = _currentPage == totalPages - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: totalPages,
                onPageChanged: (index) => setState(() => _currentPage = index),
                itemBuilder: (context, index) {
                  if (index < infoPages.length) {
                    return _buildPage(infoPages[index]);
                  } else {
                    return LocationOnboardingPage(
                      onLocationConfirmed: (double lat, double lng) {
                        ref
                            .read(socketServiceProvider)
                            .updateLocation(lat, lng);

                        ref
                            .read(onboardingProvider.notifier)
                            .completeOnboarding();
                      },
                    );
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: List.generate(
                      totalPages,
                      (index) => _buildIndicator(index == _currentPage),
                    ),
                  ),
                  if (!isLastPage)
                    FloatingActionButton.extended(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      onPressed: () {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      label: const Text(
                        "Avanti",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(OnboardingContent content) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(content.icon, size: 120, color: content.color),
          const SizedBox(height: 48),
          Text(
            content.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            content.description,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final IconData icon;
  final Color color;

  const OnboardingContent({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
  });
}
