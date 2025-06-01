import 'dart:io';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/user/user_remote_datasource.dart';
import '../../../data/repositories/user/user_repository_impl.dart';
import '../../../domain/usecases/user/user_usercase.dart';
import '../../../exceptions/app_exception.dart';
import '../auth/login_provider.dart';

class UserProfileUploadState {
  final bool isLoading;
  final bool isSuccess;
  final String? error;
  final int? errorCode;

  UserProfileUploadState({
    this.isLoading = false,
    this.isSuccess = false,
    this.error,
    this.errorCode,
  });
}

class UserProfileUploadNotifier extends StateNotifier<UserProfileUploadState> {
  final UserUsercase userUsercase;

  UserProfileUploadNotifier({
    required this.userUsercase,
  }) : super(UserProfileUploadState());

  Future<void> uploadProfileImage(File imageFile) async {
    state = UserProfileUploadState(isLoading: true);
    try {
      final result = await userUsercase.uploadProfileImage(imageFile);
      if (result.message != "") {
        state = UserProfileUploadState(
          isLoading: false,
          isSuccess: true,
          error: "",
        );
      }
    } catch (e) {
      if (e is AppException) {
        state = UserProfileUploadState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
          errorCode: e.code,
        );
      } else {
        state = UserProfileUploadState(
          isLoading: false,
          isSuccess: false,
          error: e.toString(),
        );
      }
    }
  }
}

final userProfileUploadProvider =
    StateNotifierProvider<UserProfileUploadNotifier, UserProfileUploadState>(
        (ref) {
  final authState = ref.watch(loginProvider);
  final token = authState.auth?.token;
  final remote = UserRemoteDataSourceImpl(token: token);
  final repository = UserRepositoryImpl(remote);
  return UserProfileUploadNotifier(
    userUsercase: UserUsercase(repository),
  );
});
