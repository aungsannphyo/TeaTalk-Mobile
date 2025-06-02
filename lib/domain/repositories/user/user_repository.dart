import "dart:io";

import "../../../data/models/user/search_user_response_model.dart";
import "../../../data/models/user/user_response_model.dart";
import "../../events/register_event.dart";
import "../../../data/models/common_response_model.dart";
import "../../events/user/update_personal_details_event.dart";
import "../../events/user/update_user_name_event.dart";

abstract class UserRepository {
  Future<CommonResponseModel> register(RegisterEvent register);
  Future<List<SearchUserResponseModel>> searchUser(String searchInput);
  Future<CommonResponseModel> sendFriendRequest(String reveicerID);
  Future<CommonResponseModel> uploadProfileImage(File imageFile);
  Future<CommonResponseModel> updateUserPersonalDetails(
      UpdatePersonalDetailsEvent event);
  Future<UserResponseModel> getUser();
  Future<CommonResponseModel> updateUsername(UpdateUserNameEvent event);
}
