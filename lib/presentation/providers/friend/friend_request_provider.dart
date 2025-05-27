import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/friend/friend_request_remote_datasource.dart';
import '../../../data/models/friend/friend_request_response_model.dart';
import '../../../data/repositories/friend/friend_request_repository_impl.dart';
import '../../../domain/usecases/friend/friend_request_usecase.dart';
import '../auth/login_provider.dart';

class FriendRequestState {
  final bool isLoading;
  final List<FriendRequestResponseModel>? friendRequest;
  final String? error;

  FriendRequestState({
    this.isLoading = false,
    this.friendRequest,
    this.error,
  });
}

class FriendRequestNotifier extends StateNotifier<FriendRequestState> {
  final FriendRequestUsecase friendRequestUsecase;

  FriendRequestNotifier({
    required this.friendRequestUsecase,
  }) : super(FriendRequestState());

  Future<void> getAllFriendRequestLog(String userId) async {
    state = FriendRequestState(isLoading: true);
    try {
      final result = await friendRequestUsecase.getAllFriendRequestLog(userId);
      state = FriendRequestState(friendRequest: result);
    } catch (e) {
      state = FriendRequestState(friendRequest: []);
    }
  }

  void removeRequestById(String requestId) {
    final updatedRequests = state.friendRequest
        ?.where((req) => req.requestId != requestId)
        .toList();
    state = FriendRequestState(friendRequest: updatedRequests);
  }
}

final friendRequestProvider =
    StateNotifierProvider<FriendRequestNotifier, FriendRequestState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = FriendRequestRemoteDatasourceImpl(token: token);

  final repository = FriendRequestRepositoryImpl(remote);
  return FriendRequestNotifier(
    friendRequestUsecase: FriendRequestUsecase(repository),
  );
});
