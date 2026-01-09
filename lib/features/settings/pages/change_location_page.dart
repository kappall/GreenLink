import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:greenlinkapp/features/location/models/user_location.dart';
import 'package:greenlinkapp/features/location/providers/location_provider.dart';

import '../../../core/utils/feedback_utils.dart';

class ChangeLocationPage extends ConsumerStatefulWidget {
  const ChangeLocationPage({super.key});

  @override
  ConsumerState<ChangeLocationPage> createState() => _ChangeLocationPageState();
}

class _ChangeLocationPageState extends ConsumerState<ChangeLocationPage> {
  bool _isLoading = false;
  final TextEditingController _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateLocation(double lat, double lng, String label) async {
    await ref
        .read(userLocationProvider.notifier)
        .setLocation(
          UserLocation(latitude: lat, longitude: lng, address: label),
        );
    if (mounted) {
      FeedbackUtils.showSuccess(context, "Posizione aggiornata: $label");
      Navigator.pop(context);
    }
  }

  Future<void> _useCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) FeedbackUtils.showError(context, "Permesso negato");
          return;
        }
      }

      final position = await Geolocator.getCurrentPosition();
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String label = "${position.latitude}, ${position.longitude}";
      if (placemarks.isNotEmpty) {
        final p = placemarks.first;
        label = [
          p.street,
          p.locality,
          p.administrativeArea,
          p.country,
        ].where((s) => s != null && s.isNotEmpty).join(', ');
      }

      await _updateLocation(position.latitude, position.longitude, label);
    } catch (e) {
      if (mounted) FeedbackUtils.showError(context, "Errore posizione");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _searchAddress() async {
    final inputAddress = _addressController.text.trim();
    if (inputAddress.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      List<Location> locations = await locationFromAddress(inputAddress);
      if (locations.isNotEmpty) {
        final loc = locations.first;

        final placemarks = await placemarkFromCoordinates(
          loc.latitude,
          loc.longitude,
        );

        String label = inputAddress;
        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          label = [
            p.street,
            p.locality,
            p.administrativeArea,
            p.country,
          ].where((s) => s != null && s.isNotEmpty).join(', ');
        }

        await _updateLocation(loc.latitude, loc.longitude, label);
      } else {
        if (mounted) FeedbackUtils.showError(context, "Indirizzo non trovato");
      }
    } catch (e) {
      if (mounted) FeedbackUtils.showError(context, "Errore ricerca");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userLoc = ref.watch(userLocationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Cambia Posizione")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "La tua posizione attuale impostata:",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: userLoc.when(
                data: (userLoc) => Text(
                  userLoc != null
                      ? (userLoc.address ??
                            "Coordinate: ${userLoc.latitude.toStringAsFixed(4)}, ${userLoc.longitude.toStringAsFixed(4)}")
                      : "Non impostata",
                  style: const TextStyle(fontStyle: FontStyle.italic),
                ),
                error: (e, _) {
                  return Text("Posizione non dispnibile");
                },
                loading: () => const CircularProgressIndicator(),
              ),
            ),
            const SizedBox(height: 32),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _useCurrentLocation,
                  icon: const Icon(Icons.my_location),
                  label: const Text("Usa posizione GPS attuale"),
                ),
              ),
              const SizedBox(height: 24),
              const Text("Oppure inserisci un nuovo indirizzo:"),
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
            const SizedBox(height: 40),
            Text(
              "Nota: Cambiando la posizione riceverai notifiche relative alla nuova area selezionata.",
              style: TextStyle(color: Colors.grey[600], fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
