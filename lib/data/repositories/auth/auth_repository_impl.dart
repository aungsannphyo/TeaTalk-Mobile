import '../../../domain/events/register_event.dart';
import '../../../domain/entities/auth/login_model.dart';
import '../../../domain/repositories/auth/auth_repository.dart';
import "../../datasources/auth/auth_remote_datasource.dart";
import "../../models/common_response_model.dart";

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;

  AuthRepositoryImpl(this.remote);

  @override
  Future<LoginModel> login(String email, String password) {
    return remote.login(email, password);
  }

  @override
  Future<CommonResponseModel> register(RegisterEvent register) {
    return remote.register(register);
  }
}
