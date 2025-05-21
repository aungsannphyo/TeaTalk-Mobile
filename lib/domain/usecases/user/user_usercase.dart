import '../../../data/models/common_response_model.dart';
import '../../entities/user/search_user_model.dart';
import '../../events/register_event.dart';
import '../../repositories/user/user_repository.dart';

class UserUsercase {
  final UserRepository repository;

  UserUsercase(this.repository);

  Future<CommonResponseModel> register(RegisterEvent register) {
    return repository.register(register);
  }

  Future<SearchUserModel> searchUser(String searchInput) {
    return repository.searchUser(searchInput);
  }
}
