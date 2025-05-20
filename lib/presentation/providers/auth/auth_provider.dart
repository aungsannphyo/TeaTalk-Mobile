import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/entities/auth/login_model.dart';
import '../../../domain/usecases/auth/login_usecase.dart';

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
  final LoginUseCase loginUseCase;

  AuthNotifier({
    required this.loginUseCase,
  }) : super(AuthState());

  Future<void> login(String email, String password) async {
    state = AuthState(isLoading: true);
    try {
      final result = await loginUseCase.login(email, password);
      state = AuthState(auth: result);
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
    loginUseCase: LoginUseCase(repository),
  );
});
