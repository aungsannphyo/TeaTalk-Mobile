import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/message/message_remote_datasource.dart';
import '../../../data/models/message/message_model_response.dart';
import '../../../data/repositories/message/message_repository_impl.dart';
import '../../../domain/usecases/message/message_usecase.dart';
import '../auth/login_provider.dart';

class MessagesState {
  final bool isLoading;
  final List<MessageResponseModel>? messageList;
  final String? error;

  MessagesState({
    this.isLoading = false,
    this.messageList,
    this.error,
  });
}

class MessageNotifier extends StateNotifier<MessagesState> {
  final MessageUsecase messageUsecase;

  MessageNotifier({
    required this.messageUsecase,
  }) : super(MessagesState());

  Future<void> getMessages(String conversationID, DateTime? cursorTime) async {
    state = MessagesState(isLoading: true);

    try {
      final result =
          await messageUsecase.getMessages(conversationID, cursorTime);
      state = MessagesState(messageList: result);
    } catch (e) {
      state = MessagesState(error: e.toString());
    }
  }
}

final messagesProvider =
    StateNotifierProvider<MessageNotifier, MessagesState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = MessageRemoteDatasourceImpl(token: token);

  final repository = MessageRepositoryImpl(remote);
  return MessageNotifier(
    messageUsecase: MessageUsecase(repository),
  );
});
