import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/entities/user/user_model.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../auth/login_provider.dart';

class UserState {
  final bool isLoading;
  final User? user;
  final Details? details;
  final String? error;

  UserState({
    this.isLoading = false,
    this.user,
    this.details,
    this.error,
  });
}

class GetUserNotifier extends StateNotifier<UserState> {
  final UserUsercase userUsercase;

  GetUserNotifier({
    required this.userUsercase,
  }) : super(UserState());

  Future<void> getUser() async {
    state = UserState(
      isLoading: true,
    );
    try {
      final result = await userUsercase.getUser();
      state = UserState(
        user: result.user,
        details: result.details,
        isLoading: false,
      );
    } catch (e) {
      state = UserState(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}

final getUserProvider =
    StateNotifierProvider<GetUserNotifier, UserState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return GetUserNotifier(
    userUsercase: UserUsercase(repository),
  );
});
