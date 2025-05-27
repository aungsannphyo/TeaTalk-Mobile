import '../../../domain/events/register_event.dart';
import "../../../domain/repositories/user/user_repository.dart";
import "../../datasources/user/user_remote_datasource.dart";
import "../../models/common_response_model.dart";
import "../../models/user/search_user_response_model.dart";

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remote;

  UserRepositoryImpl(this.remote);

  @override
  Future<CommonResponseModel> register(RegisterEvent register) {
    return remote.register(register);
  }

  @override
  Future<List<SearchUserResponseModel>> searchUser(String searchInput) {
    return remote.searchUser(searchInput);
  }

  @override
  Future<CommonResponseModel> sendFriendRequest(String receiverID) {
    return remote.sendFriendRequest(receiverID);
  }
}
