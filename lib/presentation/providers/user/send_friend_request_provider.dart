import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../../../exceptions/app_exception.dart';
import '../auth/login_provider.dart';

class SendFriendRequestState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final int? errorCode;

  SendFriendRequestState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.errorCode,
  });
}

class SendFriendRequestNotifier extends StateNotifier<SendFriendRequestState> {
  final UserUsercase userUsercase;

  SendFriendRequestNotifier({
    required this.userUsercase,
  }) : super(SendFriendRequestState());

  Future<void> sendFriendRequest(String receiverID) async {
    state = SendFriendRequestState(isLoading: true);
    try {
      final result = await userUsercase.sendFriendRequest(receiverID);
      if (result.message != "") {
        state = SendFriendRequestState(
          isLoading: false,
          isSuccess: true,
          error: "",
        );
      }
    } catch (e) {
      if (e is AppException) {
        state = SendFriendRequestState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
          errorCode: e.code,
        );
      } else {
        state = SendFriendRequestState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
        );
      }
    }
  }
}

final sendFriendReqProvider =
    StateNotifierProvider<SendFriendRequestNotifier, SendFriendRequestState>(
        (ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return SendFriendRequestNotifier(
    userUsercase: UserUsercase(repository),
  );
});
