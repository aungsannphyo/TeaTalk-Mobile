import "../../../domain/entities/user/search_user_model.dart";
import '../../../domain/events/register_event.dart';
import "../../../domain/repositories/user/user_repository.dart";
import "../../datasources/user/user_remote_datasource.dart";
import "../../models/common_response_model.dart";

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<CommonResponseModel> register(RegisterEvent register) {
    return remote.register(register);
  }

  @override
  Future<SearchUserModel> searchUser(String searchInput) {
    return remote.searchUser(searchInput);
  }
}
