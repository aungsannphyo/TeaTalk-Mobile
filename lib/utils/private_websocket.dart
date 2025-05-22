import 'package:web_socket_channel/web_socket_channel.dart';

class PrivateWebsocketManager {
  static final PrivateWebsocketManager _instance =
      PrivateWebsocketManager._internal();
  late final WebSocketChannel channel;

  factory PrivateWebsocketManager(String url) {
    _instance._init(url);
    return _instance;
  }

  PrivateWebsocketManager._internal();

  void _init(String url) {
    channel = WebSocketChannel.connect(Uri.parse(url));
  }
}
