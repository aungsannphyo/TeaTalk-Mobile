import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/friend/friend_request_log_datasource.dart';
import '../../../data/repositories/friend/friend_request_log_repository_impl.dart';
import '../../../domain/entities/friend/frient_request_log_model.dart';
import '../../../domain/usecases/friend/friend_request_log_usecase.dart';
import '../auth/login_provider.dart';

class FriendRequestLogState {
  final bool isLoading;
  final List<FrientRequestLogModel>? friendRequestLogs;
  final String? error;

  FriendRequestLogState({
    this.isLoading = false,
    this.friendRequestLogs,
    this.error,
  });
}

class FriendRequestLogNotifier extends StateNotifier<FriendRequestLogState> {
  final FriendRequestLogUsecase friendRequestLogUsecase;

  FriendRequestLogNotifier({
    required this.friendRequestLogUsecase,
  }) : super(FriendRequestLogState());

  Future<void> getAllFriendRequestLog(String userId) async {
    state = FriendRequestLogState(isLoading: true);
    try {
      final result =
          await friendRequestLogUsecase.getAllFriendRequestLog(userId);
      state = FriendRequestLogState(friendRequestLogs: result);
    } catch (e) {
      state = FriendRequestLogState(friendRequestLogs: []);
    }
  }
}

final friendRequestLogProvider =
    StateNotifierProvider<FriendRequestLogNotifier, FriendRequestLogState>(
        (ref) {
  final authState = ref.watch(authProvider);
  final token = authState.auth?.token;
  final remote = FriendRequestLogDatasourceImpl(token: token);

  final repository = FriendRequestLogRepositoryImpl(remote);
  return FriendRequestLogNotifier(
    friendRequestLogUsecase: FriendRequestLogUsecase(repository),
  );
});
