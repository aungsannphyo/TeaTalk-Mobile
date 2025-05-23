import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:tea_talk_mobile/domain/websocket/websocket_manager.dart';
import 'auth_token_provider.dart';
import 'chat_message_model.dart';

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

final privateMessagesProvider = StreamProvider.autoDispose<ChatMessage?>((ref) {
  final ws = ref.watch(privateWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.messages;
});

final groupMessagesProvider = StreamProvider.autoDispose<ChatMessage?>((ref) {
  final ws = ref.watch(groupWebSocketProvider);
  if (ws == null) return const Stream.empty();
  return ws.messages;
});
