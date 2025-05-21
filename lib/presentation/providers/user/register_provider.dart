import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/events/register_event.dart';
import '../../../domain/usecases/user/user_usercase.dart';

class RegisterState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;

  RegisterState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
  });
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  final UserUsercase userUsercase;

  RegisterNotifier({
    required this.userUsercase,
  }) : super(RegisterState());

  Future<void> register(RegisterEvent register) async {
    state = RegisterState(isLoading: true);
    try {
      final result = await userUsercase.register(register);
      if (result.message != "") {
        state = RegisterState(
          isLoading: false,
          isSuccess: true,
          error: "",
        );
      }
    } catch (e) {
      state = RegisterState(
        isLoading: false,
        isSuccess: false,
        error: e.toString(),
      );
    }
  }
}

final registerProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>((ref) {
  final remote = UserRemoteDataSourceImpl();
  final repository = UserRepositoryImpl(remote);
  return RegisterNotifier(
    userUsercase: UserUsercase(repository),
  );
});
