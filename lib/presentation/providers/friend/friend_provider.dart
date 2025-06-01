import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/friend/friend_remote_datasource.dart';
import '../../../data/models/friend/friend_response_model.dart';
import '../../../data/repositories/friend/friend_repository_impl.dart';
import '../../../domain/usecases/friend/friend_usercase.dart';
import '../auth/login_provider.dart';

class FriendState {
  final bool isLoading;
  final List<FriendResponseModel>? friends;
  final String? error;

  FriendState({
    this.isLoading = false,
    this.friends,
    this.error,
  });
}

class FriendNotifier extends StateNotifier<FriendState> {
  final FriendUsercase friendUsercase;

  FriendNotifier({
    required this.friendUsercase,
  }) : super(FriendState());

  Future<void> getFriends() async {
    state = FriendState(isLoading: true);

    try {
      final result = await friendUsercase.getFriends();
      state = FriendState(friends: result);
    } catch (e) {
      state = FriendState(error: e.toString());
    }
  }
}

final friendProvider =
    StateNotifierProvider<FriendNotifier, FriendState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = FriendRemoteDatasource(token: token);

  final repository = FriendRepositoryImpl(remote);
  return FriendNotifier(
    friendUsercase: FriendUsercase(repository),
  );
});
