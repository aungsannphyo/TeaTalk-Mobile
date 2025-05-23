import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/entities/auth/login_model.dart';
import '../../../domain/usecases/auth/auth_usecase.dart';
import '../../../domain/websocket/auth_token_provider.dart';
import '../../../domain/websocket/websocket_provider.dart';

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
  final Ref ref;

  AuthNotifier(
    this.ref, {
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

      ref.read(authTokenProvider.notifier).state = result.token;
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  void logout() {
    final privateWS = ref.read(privateWebSocketProvider);
    final groupWS = ref.read(groupWebSocketProvider);

    privateWS?.disconnect();
    groupWS?.disconnect();
    ref.read(authTokenProvider.notifier).state = null;
    state = AuthState();
  }
}

final loginProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final remote = AuthRemoteDataSourceImpl();
  final repository = AuthRepositoryImpl(remote);
  return AuthNotifier(
    ref,
    authUseCase: AuthUseCase(repository),
  );
});
