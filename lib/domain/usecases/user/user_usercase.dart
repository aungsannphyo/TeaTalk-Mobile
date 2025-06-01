import 'dart:io';

import '../../../data/models/common_response_model.dart';
import '../../../data/models/user/search_user_response_model.dart';
import '../../../data/models/user/user_response_model.dart';
import '../../events/register_event.dart';
import '../../events/update_personal_details_event.dart';
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

  Future<CommonResponseModel> uploadProfileImage(File imageFile) {
    return repository.uploadProfileImage(imageFile);
  }

  Future<CommonResponseModel> updateUserPersonalDetails(
      UpdatePersonalDetailsEvent event) {
    return repository.updateUserPersonalDetails(event);
  }

  Future<UserResponseModel> getUser() {
    return repository.getUser();
  }
}
