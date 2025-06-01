import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/events/update_personal_details_event.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../../../exceptions/app_exception.dart';
import '../auth/login_provider.dart';

class UpdatePersonalDetailsState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final int? errorCode;

  UpdatePersonalDetailsState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.errorCode,
  });
}

class UpdatePersonalDetailsNotifier
    extends StateNotifier<UpdatePersonalDetailsState> {
  final UserUsercase userUsercase;

  UpdatePersonalDetailsNotifier({
    required this.userUsercase,
  }) : super(UpdatePersonalDetailsState());

  Future<void> updateUserPersonalDetails(
      UpdatePersonalDetailsEvent event) async {
    state = UpdatePersonalDetailsState(isLoading: true);
    try {
      final result = await userUsercase.updateUserPersonalDetails(event);
      if (result.message != "") {
        state = UpdatePersonalDetailsState(
          isLoading: false,
          isSuccess: true,
          error: "",
        );
      }
    } catch (e) {
      if (e is AppException) {
        state = UpdatePersonalDetailsState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
          errorCode: e.code,
        );
      } else {
        state = UpdatePersonalDetailsState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
        );
      }
    }
  }
}

final updatePersonalDetailsProvider = StateNotifierProvider<
    UpdatePersonalDetailsNotifier, UpdatePersonalDetailsState>((ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return UpdatePersonalDetailsNotifier(
    userUsercase: UserUsercase(repository),
  );
});
