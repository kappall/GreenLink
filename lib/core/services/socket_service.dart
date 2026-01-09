import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenlinkapp/core/utils/feedback_utils.dart';
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

  FeedbackUtils.logDebug('Socket: provider inizializzato');
  service.connect();

  ref.listen(userLocationProvider, (previous, next) {
    if (next == null) {
      FeedbackUtils.logDebug('Socket: location non disponibile');
      return;
    }
    FeedbackUtils.logDebug(
      'Socket: location aggiornata lat=${next.latitude} lng=${next.longitude}',
    );
    service.updateLocation(next.latitude, next.longitude);
  }, fireImmediately: true);

  return service;
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
      FeedbackUtils.logDebug('Socket: avvio connessione');
      _socket.connect();
    } else {
      FeedbackUtils.logDebug('Socket: già connesso');
    }
  }

  void updateLocation(double lat, double lng) {
    FeedbackUtils.logDebug('Socket: updateLocation lat=$lat lng=$lng');
    if (_lastLat == lat && _lastLng == lng && _socket.connected) {
      FeedbackUtils.logDebug('Socket: posizione invariata, skip');
      return;
    }

    _lastLat = lat;
    _lastLng = lng;

    if (_socket.connected) {
      FeedbackUtils.logDebug('Socket: emit listen con posizione');
      _socket.emit(locationUpdateEvent, [lat, lng]);
    } else {
      FeedbackUtils.logDebug('Socket: non connesso, provo a connettere');
      _socket.connect();
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
        FeedbackUtils.logDebug('Socket: emit listen su reconnect');
        _socket.emit(locationUpdateEvent, [_lastLat, _lastLng]);
      } else {
        FeedbackUtils.logDebug('Socket: connesso senza posizione');
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
      FeedbackUtils.logInfo('Socket: content ricevuto $payload');
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
