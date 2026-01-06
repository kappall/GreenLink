import 'package:flutter_riverpod/legacy.dart';

import '../../../core/providers/geocoding_provider.dart';

final userLocationProvider = StateProvider<GeoKey?>((ref) => null);
