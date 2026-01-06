import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

final socketServiceProvider = Provider((ref) {
  final socket = IO.io('https://qualcosa', <String, dynamic>{
    'transports': ['websocket'], //TODO: completa
    'autoConnect': false,
  });

  return SocketService(socket);
});

class SocketService {
  final IO.Socket _socket;

  SocketService(this._socket);

  void updateLocation(double lat, double lng) {
    if (!_socket.connected) _socket.connect();

    _socket.emit('update_location_notifications', {
      'lat': lat,
      'lng': lng,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }
}
