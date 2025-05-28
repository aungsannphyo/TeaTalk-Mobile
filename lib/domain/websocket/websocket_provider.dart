import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../presentation/providers/auth/login_provider.dart';
import 'chat_message_model.dart';
import 'online_status_model.dart';
import 'websocket_manager.dart';

final privateWebSocketProvider = Provider<WebsocketManagerController?>((ref) {
  final wsUrl = dotenv.env['WS_URL'];
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
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
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
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
  final authState = ref.watch(loginProvider);
  final currentUserId = authState.auth?.id;
  return ws.messagesStream.where(
    (msg) => msg.senderId == targetId && msg.targetId == currentUserId,
  );
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
