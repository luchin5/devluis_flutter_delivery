import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class NotificationsService {
  static final NotificationsService _instance =
      NotificationsService._internal();
  factory NotificationsService() => _instance;
  NotificationsService._internal();

  bool _isSilenced = false;

  bool _isInitialized = false;
  final notificationsPlugin = FlutterLocalNotificationsPlugin();
  //CAMBIOS
  /*
  void initProvider(PedidosProvider provider) {
    _pedidosProvider = provider;
  }*/

  // Solicitar permisos de notificación
  Future<void> requestNotificationPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.notification.status;
      if (status.isDenied || status.isPermanentlyDenied) {
        await Permission.notification.request();
      }
    }
  }

  // Inicialización de las notificaciones
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // Configuración para Android
    const initSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Configuración para iOS
    const initSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Configuración general
    final initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    try {
      // Inicializar las notificaciones y manejar respuestas
      await notificationsPlugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: onNotificationResponse,
      );
      _isInitialized = true;
    } catch (e) {
      print('Error al inicializar las notificaciones: $e');
    }
  }

  //dispose notification
  // Método para destruir la instancia de notificaciones
  Future<void> disposeNotifications() async {
    try {
      await notificationsPlugin.cancelAll(); // Cancela todas las notificaciones
      _isInitialized = false; // Resetea el estado de inicialización
      print("🚫 Notificaciones eliminadas y desinicializadas.");
    } catch (e) {
      print("❌ Error al destruir las notificaciones: $e");
    }
  }

  // Manejo de respuestas a las acciones de la notificación
  void onNotificationResponse(NotificationResponse response) {
    final actionId = response.actionId;
    final payload = response.payload;
    //if (payload == null) return;
    //if (actionId == null) return;
    print("ENTRANDO A NOTIFICATIONS -------> $actionId");
    switch (actionId) {
      case 'accept_order':
        print("La acción 'Aceptar' fue seleccionada");
        print(payload);
        // Lógica para aceptar
        // Obtener la instancia de provider ya no una diferente sino una que contenga la misma
        //_pedidosProvider.aceptarPedido(pedidoId, pedidoData: pedidoData);
        /*
        print(
            "ULTIMO PEDIDO ID -------->>>>>>${_pedidosProvider.ultimoPedidoAceptado?.id}");
        */
        break;
      case 'view_order':
        print("Acción 'Ver' seleccionada para pedido");
        // Lógica para denegar
        break;
      case null: // Si `actionId` es nulo, significa que tocaron la notificación
        print("Notificación tocada, abrir aplicación");
        // Aquí navega a la pantalla principal o a la del pedido
        break;
      default:
        print("Otra acción seleccionada: $actionId");
        // Acción no manejada
        break;
    }
  }

  void silenceNotifications(bool silence) async {
    _isSilenced = silence;
    if (silence) {
      await notificationsPlugin
          .cancelAll(); // Cancela todas las notificaciones activas
      print("Todas las notificaciones han sido canceladas.");
    }
  }

  // Manejo de clics en las notificaciones
  void onSelectNotification(String? payload) async {
    if (payload != null) {
      print('Notification payload: $payload');
      // Aquí puedes manejar la lógica al hacer clic en una acción
    }
  }

  // Detalles de la notificación con acciones
  NotificationDetails notificationDetailsWithActions(
      {required String title, required String body}) {
    final bigTextStyle = BigTextStyleInformation(
        body, // Texto largo que aparecerá al expandir la notificación
        contentTitle:
            title //'🛍️ ¡Oferta Exclusiva Hoy!', // Título visible al expandir
        //   summaryText: '🔥 Descuentos increíbles disponibles', // Línea inferior
        );
    final androidChannel = AndroidNotificationDetails(
      'orders_channel',
      'Order Notifications',
      channelDescription: 'Notificaciones de pedidos nuevos',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      setAsGroupSummary: false,
      styleInformation: bigTextStyle,
      /* actions: [
        AndroidNotificationAction(
            'accept_order', // ID de la acción
            'Aceptar', // Título del botón
            showsUserInterface: true),
        AndroidNotificationAction(
            'view_order', // ID de la acción
            'Ver', // Título del botón
            showsUserInterface: true),
      ],*/
    );

    final iOSChannel = DarwinNotificationDetails();
    return NotificationDetails(android: androidChannel, iOS: iOSChannel);
  }

  // Mostrar una notificación con acción
  Future<void> showOrderNotification({
    int? id,
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!_isInitialized) await initNotification();
    try {
      await notificationsPlugin.show(
        id!,
        title,
        body,
        notificationDetailsWithActions(body: body, title: title),
        payload: payload, // Verifica que el payload se pase correctamente
      );
    } catch (e) {
      print('Error al mostrar la notificación: $e');
    }
  }
}
