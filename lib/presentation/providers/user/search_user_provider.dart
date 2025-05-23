import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/entities/user/search_user_model.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../auth/login_provider.dart';

class SearchUserState {
  final bool isLoading;
  final List<SearchUserModel> users;
  final String? error;

  SearchUserState({
    this.isLoading = false,
    required this.users,
    this.error,
  });
}

class SearchUserNotifier extends StateNotifier<SearchUserState> {
  final UserUsercase userUsercase;

  SearchUserNotifier({
    required this.userUsercase,
  }) : super(SearchUserState(users: []));

  Future<void> searchUser(String searchInput) async {
    state = SearchUserState(isLoading: true, users: []);
    try {
      final result = await userUsercase.searchUser(searchInput);
      state = SearchUserState(
        users: result,
        isLoading: false,
      );
    } catch (e) {
      state = SearchUserState(
        isLoading: false,
        users: [],
        error: e.toString(),
      );
    }
  }

  void reset() {
    state = SearchUserState(users: []);
  }
}

final searchUserProvider =
    StateNotifierProvider<SearchUserNotifier, SearchUserState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return SearchUserNotifier(
    userUsercase: UserUsercase(repository),
  );
});
