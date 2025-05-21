import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/entities/auth/login_model.dart';
import '../../../domain/usecases/auth/auth_usecase.dart';

class AuthState {
  final bool isLoading;
  final LoginModel? auth;
  final String? error;

  AuthState({
    this.isLoading = false,
    this.auth,
    this.error,
  });

  bool get isAuthenticated => auth != null;
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUseCase authUseCase;

  AuthNotifier({
    required this.authUseCase,
  }) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final result = await authUseCase.login(email, password);
      state = AuthState(
        auth: result,
        isLoading: false,
      );
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  void logout() {
    state = AuthState();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final remote = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(remote);
  return AuthNotifier(
    authUseCase: AuthUseCase(repository),
  );
});
