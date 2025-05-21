import "../../entities/user/search_user_model.dart";
import "../../events/register_event.dart";
import "../../../data/models/common_response_model.dart";

abstract class UserRepository {
  Future<CommonResponseModel> register(RegisterEvent register);
  Future<SearchUserModel> searchUser(String searchInput);
  Future<CommonResponseModel> sendFriendRequest(String reveicerID);
}
