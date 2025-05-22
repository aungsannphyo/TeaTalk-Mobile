import '../../entities/friend/friend_model.dart';
import '../../repositories/friend/friend_repository.dart';

class FriendUsercase {
  final FriendRepository repository;

  FriendUsercase(this.repository);

  Future<List<FriendModel>> getFriends() {
    return repository.getFriends();
  }
}
