import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/conversation/conversation_remote_datasource.dart';
import '../../../data/repositories/conversation/conversation_repository_impl.dart';
import '../../../domain/entities/conversation/conversation_model.dart';
import '../../../domain/usecases/conversation/conversation_usecase.dart';
import '../auth/login_provider.dart';

class ConversationState {
  final bool isLoading;
  final List<ConversationModel>? conversationList;
  final String? error;

  ConversationState({
    this.isLoading = false,
    this.conversationList,
    this.error,
  });
}

class ConversationNotifier extends StateNotifier<ConversationState> {
  final ConversationUsecase conversationUsecase;

  ConversationNotifier({
    required this.conversationUsecase,
  }) : super(ConversationState());

  Future<void> getConversations(String userID) async {
    state = ConversationState(isLoading: true);

    try {
      final result = await conversationUsecase.getConversations(userID);
      state = ConversationState(conversationList: result);
    } catch (e) {
      state = ConversationState(error: e.toString());
    }
  }
}

final conversationProvider =
    StateNotifierProvider<ConversationNotifier, ConversationState>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.auth?.token;
  final remote = ConversationRemoteDataSourceImpl(token: token);

  final repository = ConversationRepositoryImpl(remote);
  return ConversationNotifier(
    conversationUsecase: ConversationUsecase(repository),
  );
});
