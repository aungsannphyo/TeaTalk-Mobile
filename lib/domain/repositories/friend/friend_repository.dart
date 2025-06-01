import '../../../data/models/friend/friend_response_model.dart';

abstract class FriendRepository {
  Future<List<FriendResponseModel>> getFriends();
}
