import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'auth_token_provider.dart';
import 'chat_message_model.dart';
import 'online_status_model.dart';
import 'websocket_manager.dart';

final privateWebSocketProvider = Provider<WebsocketManagerController?>((ref) {
  final wsUrl = dotenv.env['WS_URL'];
  final token = ref.watch(authTokenProvider);
  if (token == null) return null;

  final controller = WebsocketManagerController(
    baseUrl: '$wsUrl/ws/private',
    token: token,
  );

  ref.onDispose(controller.dispose);
  return controller;
});

final groupWebSocketProvider = Provider<WebsocketManagerController?>((ref) {
  final wsUrl = dotenv.env['WS_URL'];
  final token = ref.watch(authTokenProvider);
  if (token == null) return null;

  final controller = WebsocketManagerController(
    baseUrl: '$wsUrl/ws/group',
    token: token,
  );

  ref.onDispose(controller.dispose);
  return controller;
});

final privateMessagesProvider =
    StreamProvider.family<ChatMessageModel?, String>((ref, targetId) {
  final ws = ref.watch(privateWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.messagesStream.where((msg) => msg.targetId == targetId);
});

final groupMessagesProvider = StreamProvider<ChatMessageModel?>((ref) {
  final ws = ref.watch(groupWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.messagesStream;
});

final privateStatusProvider = StreamProvider<OnlineStatusModel?>((ref) {
  final ws = ref.watch(privateWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.statusStream;
});

final groupStatusProvider = StreamProvider<OnlineStatusModel?>((ref) {
  final ws = ref.watch(groupWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.statusStream;
});
