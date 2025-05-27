import '../../../data/models/common_response_model.dart';
import '../../../data/models/user/search_user_response_model.dart';
import '../../events/register_event.dart';
import '../../repositories/user/user_repository.dart';

class UserUsercase {
  final UserRepository repository;

  UserUsercase(this.repository);

  Future<CommonResponseModel> register(RegisterEvent register) {
    return repository.register(register);
  }

  Future<List<SearchUserResponseModel>> searchUser(String searchInput) {
    return repository.searchUser(searchInput);
  }

  Future<CommonResponseModel> sendFriendRequest(String receiverID) {
    return repository.sendFriendRequest(receiverID);
  }
}
