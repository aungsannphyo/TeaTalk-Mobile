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

  MessagesState copyWith({
    bool? isLoading,
    List<MessageResponseModel>? messageList,
    String? error,
  }) {
    return MessagesState(
      isLoading: isLoading ?? this.isLoading,
      messageList: messageList ?? this.messageList,
      error: error ?? this.error,
    );
  }
}

class MessageNotifier extends StateNotifier<MessagesState> {
  final MessageUsecase messageUsecase;

  MessageNotifier({required this.messageUsecase}) : super(MessagesState());

  Future<void> getMessages(String conversationID, DateTime? cursorTime) async {
    state = state.copyWith(isLoading: true);

    try {
      final List<MessageResponseModel> result =
          await messageUsecase.getMessages(conversationID, cursorTime);

      final List<MessageResponseModel> mergedList = (cursorTime == null)
          ? result
          : [...(state.messageList ?? []), ...result];

      state = state.copyWith(
        messageList: mergedList,
        isLoading: false,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void addMessage(MessageResponseModel message) {
    final currentList = state.messageList ?? [];

    if (!currentList.any((m) => m.messageId == message.messageId)) {
      state = state.copyWith(
        messageList: [...currentList, message],
      );
    }
  }
}

final messagesProvider =
    StateNotifierProvider<MessageNotifier, MessagesState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = MessageRemoteDatasourceImpl(token: token);
  final repository = MessageRepositoryImpl(remote);
  return MessageNotifier(messageUsecase: MessageUsecase(repository));
});
