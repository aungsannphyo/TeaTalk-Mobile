import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/entities/user/user_model.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../auth/login_provider.dart';

class SearchUserState {
  final bool isLoading;
  final UserModel? user;
  final String? error;

  SearchUserState({
    this.isLoading = false,
    this.user,
    this.error,
  });
}

class SearchUserNotifier extends StateNotifier<SearchUserState> {
  final UserUsercase userUsercase;

  SearchUserNotifier({
    required this.userUsercase,
  }) : super(SearchUserState());

  Future<void> searchUser(String searchInput) async {
    state = SearchUserState(isLoading: true);
    try {
      await userUsercase.searchUser(searchInput);
    } catch (e) {
      state = SearchUserState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final searchUserProvider =
    StateNotifierProvider<SearchUserNotifier, SearchUserState>((ref) {
  final authState = ref.watch(authProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return SearchUserNotifier(
    userUsercase: UserUsercase(repository),
  );
});
