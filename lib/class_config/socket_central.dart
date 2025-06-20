import 'package:app2025_final/class_config/clase_notificacion.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();
  int _contador = 0;
  late IO.Socket _socket;
  final NotificationsService _notiService = NotificationsService();
  String api = dotenv.env['API_URL'] ?? '';
  void connectToSocket() {
    _socket = IO.io(
      "$api:5013", // Ej: http://192.168.1.100:3000
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // Si prefieres conectarte manualmente
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('🔌 Conectado a socket');
    });

    _socket.on('notify_cliente', (data) async {
      final int id = data['id'] ?? 1;
      final String title = data['titulo'] ?? 'Notificación';
      final String body = data['descripcion'] ?? 'Tienes un nuevo mensaje';
      final String payload = data['descripcion'] ?? 'sin_datos';

      _notiService.showOrderNotification(
        id: id,
        title: title,
        body: body,
        payload: payload,
      );
    });

    _socket.onDisconnect((_) {
      print('🔌 Desconectado del socket');
    });

    _socket.onError((err) {
      print('❌ Socket error: $err');
    });
  }

  void disconnectSocket() {
    _socket.disconnect();
  }
}
