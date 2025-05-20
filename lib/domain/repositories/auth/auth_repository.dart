import "../../entities/auth/login_model.dart";

abstract class AuthRepository {
  Future<LoginModel> login(String email, String password);
}
