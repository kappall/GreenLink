import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
import 'package:greenlinkapp/features/auth/providers/auth_provider.dart';
import 'package:greenlinkapp/features/location/providers/location_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

const _socketBaseUrl = 'https://greenlink.tommasodeste.it';

final socketServiceProvider = Provider<SocketService>((ref) {
  final socket = IO.io(_socketBaseUrl, <String, dynamic>{
    'transports': ['websocket'],
    'autoConnect': false,
    'reconnection': true,
    'reconnectionAttempts': 5,
    'reconnectionDelay': 1000,
  });

  final service = SocketService(socket);
  ref.onDispose(service.dispose);

  ref.listen(authProvider, (_, next) {
    final isAuthenticated = next.asData?.value.isAuthenticated ?? false;
    if (isAuthenticated) {
      service.connect();
    } else {
      service.disconnect();
    }
  });

  ref.listen(userLocationProvider, (previous, next) {
    if (next.value == null) {
      return;
    }
    service.updateLocation(next.value!.latitude, next.value!.longitude);
  }, fireImmediately: true);

  return service;
});

/// Provider per esporre lo stream di notifiche alla UI
final notificationStreamProvider =
    StreamProvider.autoDispose<Map<String, dynamic>>((ref) {
      final socketService = ref.watch(socketServiceProvider);
      return socketService.notifications;
    });

class SocketService {
  static const String locationUpdateEvent = 'listen';
  static const String notificationEvent = 'content';

  final IO.Socket _socket;
  final StreamController<Map<String, dynamic>> _notificationsController =
      StreamController.broadcast();
  double? _lastLat;
  double? _lastLng;

  SocketService(this._socket) {
    _registerHandlers();
  }

  Stream<Map<String, dynamic>> get notifications =>
      _notificationsController.stream;

  void connect() {
    if (!_socket.connected) {
      _socket.connect();
    }
  }

  void updateLocation(double lat, double lng) {
    if (_lastLat == lat && _lastLng == lng && _socket.connected) {
      return; // Posizione invariata, non fare nulla
    }

    _lastLat = lat;
    _lastLng = lng;

    if (_socket.connected) {
      _socket.emit(locationUpdateEvent, [lat, lng]);
    }
  }

  void disconnect() {
    if (_socket.connected) {
      _socket.disconnect();
    }
  }

  void dispose() {
    _notificationsController.close();
    _socket.dispose();
  }

  void _registerHandlers() {
    _socket.on('connect', (_) {
      FeedbackUtils.logInfo('Socket connesso');
      if (_lastLat != null && _lastLng != null) {
        _socket.emit(locationUpdateEvent, [_lastLat, _lastLng]);
      }
    });
    _socket.on('disconnect', (_) {
      FeedbackUtils.logInfo('Socket disconnesso');
    });
    _socket.on('connect_error', (error) {
      FeedbackUtils.logError('Errore socket: $error');
    });
    _socket.on(notificationEvent, (data) {
      final payload = _normalizePayload(data);
      _notificationsController.add(payload);
    });
  }

  Map<String, dynamic> _normalizePayload(dynamic data) {
    if (data is Map<String, dynamic>) {
      return data;
    }
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is List && data.length >= 2) {
      return {'contentId': data[0], 'type': data[1]};
    }
    return {'data': data};
  }
}
