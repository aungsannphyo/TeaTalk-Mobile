import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/friend/friend_request_datasource.dart';
import '../../../data/repositories/friend/friend_request_repository_impl.dart';
import '../../../domain/events/decide_friend_request_event.dart';
import '../../../domain/usecases/friend/friend_request_usecase.dart';
import '../auth/login_provider.dart';

class DecideFriendRequestState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final String? lastHandledRequestId;
  final FriendRequestStatus? lastAction;

  DecideFriendRequestState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.lastHandledRequestId,
    this.lastAction,
  });
}

class DecideFriendRequestNotifier
    extends StateNotifier<DecideFriendRequestState> {
  final FriendRequestUsecase friendRequestUsecase;

  DecideFriendRequestNotifier({
    required this.friendRequestUsecase,
  }) : super(DecideFriendRequestState());

  Future<void> decideFriendRequest(DecideFriendRequestEvent event) async {
    state = DecideFriendRequestState(isLoading: true);
    try {
      final result = await friendRequestUsecase.decideFriendRequest(event);
      if (result.message != "") {
        state = DecideFriendRequestState(
          isSuccess: true,
          lastHandledRequestId: event.friendRequestId,
          lastAction: event.status == FriendRequestStatus.accepted.value
              ? FriendRequestStatus.accepted
              : FriendRequestStatus.rejected,
        );
      }
    } catch (e) {
      state = DecideFriendRequestState(
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = DecideFriendRequestState();
  }
}

final decideFriendRequestProvider = StateNotifierProvider<
    DecideFriendRequestNotifier, DecideFriendRequestState>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.auth?.token;
  final remote = FriendRequestDatasourceImpl(token: token);

  final repository = FriendRequestRepositoryImpl(remote);
  return DecideFriendRequestNotifier(
    friendRequestUsecase: FriendRequestUsecase(repository),
  );
});
