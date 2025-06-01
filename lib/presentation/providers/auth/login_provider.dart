import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../data/datasources/auth/auth_remote_datasource.dart';
import '../../../data/models/auth/login_response_model.dart';
import '../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../domain/usecases/auth/auth_usecase.dart';
import '../../../domain/websocket/websocket_provider.dart';

class AuthState {
  final bool isLoading;
  final LoginResponseModel? auth;
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
    } catch (e) {
      state = AuthState(error: e.toString());
    }
  }

  void logout() {
    final privateWS = ref.container.read(privateWebSocketProvider);
    final groupWS = ref.container.read(groupWebSocketProvider);

    privateWS?.disconnect();
    groupWS?.disconnect();
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
