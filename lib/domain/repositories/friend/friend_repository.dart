import '../../entities/friend/friend_model.dart';

abstract class FriendRepository {
  Future<List<FriendModel>> getFriends();
}
