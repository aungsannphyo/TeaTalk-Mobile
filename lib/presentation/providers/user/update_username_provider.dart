import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/events/user/update_user_name_event.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../../../exceptions/app_exception.dart';
import '../auth/login_provider.dart';

class UpdateUserNameState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final int? errorCode;

  UpdateUserNameState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.errorCode,
  });
}

class UpdateUserNameNotifier extends StateNotifier<UpdateUserNameState> {
  final UserUsercase userUsercase;

  UpdateUserNameNotifier({
    required this.userUsercase,
  }) : super(UpdateUserNameState());

  Future<void> updateUsername(UpdateUserNameEvent event) async {
    state = UpdateUserNameState(isLoading: true);
    try {
      final result = await userUsercase.updateUsername(event);
      if (result.message != "") {
        state = UpdateUserNameState(
          isLoading: false,
          isSuccess: true,
          error: "",
        );
      }
    } catch (e) {
      if (e is AppException) {
        state = UpdateUserNameState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
          errorCode: e.code,
        );
      } else {
        state = UpdateUserNameState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
        );
      }
    }
  }
}

final updateUserNameProvider =
    StateNotifierProvider<UpdateUserNameNotifier, UpdateUserNameState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return UpdateUserNameNotifier(
    userUsercase: UserUsercase(repository),
  );
});
