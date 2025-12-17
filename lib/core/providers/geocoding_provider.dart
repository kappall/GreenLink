import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';

typedef GeoKey = ({double lat, double lng});

final placeNameProvider = FutureProvider.family<String, GeoKey>((
  ref,
  key,
) async {
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      key.lat,
      key.lng,
    );

    if (placemarks.isEmpty) {
      return "Indirizzo non disponibile";
    }

    final Placemark placemark = placemarks.first;

    final street = placemark.street ?? '';
    final locality = placemark.locality ?? '';
    final country = placemark.country ?? '';

    return [street, locality, country].where((s) => s.isNotEmpty).join(', ');
  } catch (e) {
    print("Geocoding Error: $e");
    return "Errore Geocoding";
  }
});
