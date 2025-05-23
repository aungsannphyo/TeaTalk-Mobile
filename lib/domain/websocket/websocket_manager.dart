import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:web_socket_channel/web_socket_channel.dart';

import 'chat_message_model.dart';

enum ConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

class WebsocketManagerController {
  WebSocketChannel? _channel;
  final _incomingController = StreamController<ChatMessage>.broadcast();
  final _outbox = <ChatMessage>[];
  Timer? _reconnectTimer;
  Timer? _heartbeatTimer;
  int _reconnectAttempts = 0;
  bool _intentionalClose = false;
  final String _baseUrl;
  final String _token;

  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionStatus get status => _status;
  bool get isConnected => _status == ConnectionStatus.connected;

  WebsocketManagerController({required String baseUrl, required String token})
      : _baseUrl = baseUrl,
        _token = token;

  Stream<ChatMessage> get messages => _incomingController.stream;

  Future<void> connect() async {
    if (_channel != null) return;

    _setStatus(ConnectionStatus.connecting);

    try {
      final uri = Uri.parse('$_baseUrl?token=$_token');
      _channel = WebSocketChannel.connect(uri);

      _channel!.stream.listen(
        _onData,
        onDone: _onDone,
        onError: (_) => _onDone(),
      );

      _startHeartbeat();
      _flushOutbox();
      _setStatus(ConnectionStatus.connected);
      _reconnectAttempts = 0;
      _intentionalClose = false;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void send(ChatMessage msg) {
    if (_channel != null && _status == ConnectionStatus.connected) {
      _channel!.sink.add(json.encode(msg.toJson()));
    } else {
      _outbox.add(msg);
    }
  }

  void _flushOutbox() {
    for (final msg in _outbox) {
      send(msg);
    }
    _outbox.clear();
  }

  void _onData(dynamic data) {
    try {
      final decoded = json.decode(data);
      final message = ChatMessage.fromJson(decoded);
      _incomingController.add(message);
    } catch (_) {}
  }

  void _onDone() {
    _channel = null;
    _stopHeartbeat();
    if (_intentionalClose) return;
    _setStatus(ConnectionStatus.disconnected);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_intentionalClose) return;

    _setStatus(ConnectionStatus.reconnecting);
    final delay = min(pow(2, _reconnectAttempts++), 30).toInt();

    _reconnectTimer = Timer(Duration(seconds: delay), () {
      connect();
    });
  }

  void _startHeartbeat() {
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_channel == null) {
        _scheduleReconnect();
      }
    });
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  void disconnect() {
    _intentionalClose = true;
    _reconnectTimer?.cancel();
    _stopHeartbeat();
    _channel?.sink.close();
    _channel = null;
    _setStatus(ConnectionStatus.disconnected);
  }

  void _setStatus(ConnectionStatus newStatus) {
    _status = newStatus;
  }

  void dispose() {
    disconnect();
    _incomingController.close();
  }
}
