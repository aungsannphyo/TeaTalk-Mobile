import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/conversation/conversation_remote_datasource.dart';
import '../../../data/models/conversation/conversation_response_model.dart';
import '../../../data/repositories/conversation/conversation_repository_impl.dart';
import '../../../domain/events/get_conversation_event.dart';
import '../../../domain/usecases/conversation/conversation_usecase.dart';
import '../auth/login_provider.dart';

class ConversationState {
  final bool isLoading;
  final ConversationResponseModel? conversation;
  final String? error;

  const ConversationState({
    this.isLoading = false,
    this.conversation,
    this.error,
  });

  ConversationState copyWith({
    bool? isLoading,
    ConversationResponseModel? conversation,
    String? error,
    bool? isCreated,
  }) {
    return ConversationState(
      isLoading: isLoading ?? this.isLoading,
      conversation: conversation ?? this.conversation,
      error: error,
    );
  }
}

class ConversationNotifier extends StateNotifier<ConversationState> {
  final ConversationUsecase conversationUsecase;

  ConversationNotifier({
    required this.conversationUsecase,
  }) : super(ConversationState());

  Future<void> getConversation(
    GetConversationEvent getEvent,
  ) async {
    state = ConversationState(isLoading: true);

    try {
      final conversation = await conversationUsecase.getConversation(getEvent);
      state = state.copyWith(conversation: conversation, isLoading: false);
    } catch (e) {
      state = ConversationState(error: e.toString());
    }
  }
}

final conversationProvider =
    StateNotifierProvider<ConversationNotifier, ConversationState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = ConversationRemoteDataSourceImpl(token: token);
  final repository = ConversationRepositoryImpl(remote);
  return ConversationNotifier(
    conversationUsecase: ConversationUsecase(repository),
  );
});
