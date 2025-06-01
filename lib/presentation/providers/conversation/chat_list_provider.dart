import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/conversation/conversation_remote_datasource.dart';
import '../../../data/models/conversation/chat_list_response_model.dart';
import '../../../data/repositories/conversation/conversation_repository_impl.dart';
import '../../../domain/usecases/conversation/conversation_usecase.dart';
import '../auth/login_provider.dart';

class ChatListState {
  final bool isLoading;
  final List<ChatListResponseModel>? conversationList;
  final String? error;

  ChatListState({
    this.isLoading = false,
    this.conversationList,
    this.error,
  });
}

class ChatListNotifier extends StateNotifier<ChatListState> {
  final ConversationUsecase conversationUsecase;

  ChatListNotifier({
    required this.conversationUsecase,
  }) : super(ChatListState());

  Future<void> getChatList() async {
    state = ChatListState(isLoading: true);

    try {
      final result = await conversationUsecase.getChatList();
      state = ChatListState(conversationList: result);
    } catch (e) {
      state = ChatListState(error: e.toString());
    }
  }
}

final chatListProvider =
    StateNotifierProvider<ChatListNotifier, ChatListState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = ConversationRemoteDataSourceImpl(token: token);

  final repository = ConversationRepositoryImpl(remote);
  return ChatListNotifier(
    conversationUsecase: ConversationUsecase(repository),
  );
});
