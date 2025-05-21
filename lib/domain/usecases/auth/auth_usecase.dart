import '../../entities/auth/login_model.dart';
import '../../repositories/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<LoginModel> login(String email, String password) {
    return repository.login(email, password);
  }
}
