import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/friend/friend_remote_datasource.dart';
import '../../../data/models/friend/friend_response_model.dart';
import '../../../data/repositories/friend/friend_repository_impl.dart';
import '../../../domain/usecases/friend/friend_usercase.dart';
import '../auth/login_provider.dart';

class FiendState {
  final bool isLoading;
  final List<FriendResponseModel>? friends;
  final String? error;

  FiendState({
    this.isLoading = false,
    this.friends,
    this.error,
  });
}

class FriendNotifier extends StateNotifier<FiendState> {
  final FriendUsercase friendUsercase;

  FriendNotifier({
    required this.friendUsercase,
  }) : super(FiendState());

  Future<void> getFriends() async {
    state = FiendState(isLoading: true);

    try {
      final result = await friendUsercase.getFriends();
      state = FiendState(friends: result);
    } catch (e) {
      state = FiendState(error: e.toString());
    }
  }
}

final friendProvider = StateNotifierProvider<FriendNotifier, FiendState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = FriendRemoteDatasource(token: token);

  final repository = FriendRepositoryImpl(remote);
  return FriendNotifier(
    friendUsercase: FriendUsercase(repository),
  );
});
