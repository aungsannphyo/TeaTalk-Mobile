import '../../../data/models/friend/friend_response_model.dart';
import '../../repositories/friend/friend_repository.dart';

class FriendUsercase {
  final FriendRepository repository;

  FriendUsercase(this.repository);

  Future<List<FriendResponseModel>> getFriends() {
    return repository.getFriends();
  }
}
