import '../../../data/models/auth/login_response_model.dart';
import '../../repositories/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;

  AuthUseCase(this.repository);

  Future<LoginResponseModel> login(String email, String password) {
    return repository.login(email, password);
  }
}
