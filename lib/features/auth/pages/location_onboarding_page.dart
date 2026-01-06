import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenlinkapp/features/location/models/user_location.dart';
import 'package:greenlinkapp/features/location/providers/location_provider.dart';

import '../../../core/utils/feedback_utils.dart';

class LocationOnboardingPage extends ConsumerStatefulWidget {
  final Function(double, double) onLocationConfirmed;

  const LocationOnboardingPage({super.key, required this.onLocationConfirmed});

  @override
  ConsumerState<LocationOnboardingPage> createState() =>
      _LocationOnboardingPageState();
}

class _LocationOnboardingPageState
    extends ConsumerState<LocationOnboardingPage> {
  bool _isLocating = false;
  String? _selectedAddress;
  double? _currentLat;
  double? _currentLng;
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() {
      _isLocating = true;
      _selectedAddress = null;
      _currentLat = null;
      _currentLng = null;
    });
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) FeedbackUtils.showError(context, "Permesso negato");
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) {
          FeedbackUtils.showError(context, "Permessi negati permanentemente");
        }
        return;
      }

      final position = await Geolocator.getCurrentPosition();
      _currentLat = position.latitude;
      _currentLng = position.longitude;

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        setState(() {
          _selectedAddress = [
            p.street,
            p.locality,
            p.administrativeArea,
            p.country,
          ].where((s) => s != null && s.isNotEmpty).join(', ');
        });
      } else {
        setState(() {
          _selectedAddress = "${position.latitude}, ${position.longitude}";
        });
      }
    } catch (e) {
      if (mounted) {
        FeedbackUtils.showError(context, "Errore nel recupero della posizione");
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _searchAddress() async {
    final inputAddress = _addressController.text.trim();
    if (inputAddress.isEmpty) return;

    setState(() {
      _isLocating = true;
      _selectedAddress = null;
      _currentLat = null;
      _currentLng = null;
    });
    try {
      List<Location> locations = await locationFromAddress(inputAddress);
      if (locations.isNotEmpty) {
        final loc = locations.first;
        _currentLat = loc.latitude;
        _currentLng = loc.longitude;

        // Eseguiamo il reverse geocoding per ottenere il nome normalizzato
        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          setState(() {
            _selectedAddress = [
              p.street,
              p.locality,
              p.administrativeArea,
              p.country,
            ].where((s) => s != null && s.isNotEmpty).join(', ');
          });
        } else {
          setState(() {
            _selectedAddress = inputAddress;
          });
        }
      } else {
        if (mounted) FeedbackUtils.showError(context, "Indirizzo non trovato");
      }
    } catch (e) {
      if (mounted) {
        FeedbackUtils.showError(context, "Errore durante la ricerca");
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Icon(
              Icons.location_on_outlined,
              size: 120,
              color: Colors.blue,
            ),
            const SizedBox(height: 48),
            const Text(
              "Dove ti trovi?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "GreenLink personalizza la tua esperienza in base alla tua posizione per mostrarti segnalazioni ed eventi vicini a te.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey, height: 1.5),
            ),
            const SizedBox(height: 40),
            if (_isLocating)
              const CircularProgressIndicator()
            else if (_selectedAddress != null) ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _selectedAddress!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => setState(() => _selectedAddress = null),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FloatingActionButton.extended(
                  onPressed: () {
                    if (_currentLat != null && _currentLng != null) {
                      ref
                          .read(userLocationProvider.notifier)
                          .setLocation(
                            UserLocation(
                              latitude: _currentLat!,
                              longitude: _currentLng!,
                              address: _selectedAddress,
                            ),
                          );
                      widget.onLocationConfirmed(_currentLat!, _currentLng!);
                    }
                  },
                  label: const Text(
                    "Inizia ora",
                    style: TextStyle(color: Colors.white),
                  ),
                  icon: const Icon(Icons.rocket_launch, color: Colors.white),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _useCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Usa la mia posizione"),
                ),
              ),
              const SizedBox(height: 16),
              const Text("oppure inserisci un indirizzo"),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        hintText: "Città, Via...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      onSubmitted: (_) => _searchAddress(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _searchAddress,
                    icon: const Icon(Icons.search),
                    style: IconButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(14),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
