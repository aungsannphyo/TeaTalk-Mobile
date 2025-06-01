import '../../../domain/repositories/friend/friend_repository.dart';
import '../../datasources/friend/friend_remote_datasource.dart';
import '../../models/friend/friend_response_model.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendDatasource remote;

  FriendRepositoryImpl(this.remote);

  @override
  Future<List<FriendResponseModel>> getFriends() {
    return remote.getFriends();
  }
}
