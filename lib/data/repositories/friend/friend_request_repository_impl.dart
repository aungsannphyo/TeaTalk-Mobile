import '../../../domain/events/decide_friend_request_event.dart';
import '../../../domain/repositories/friend/friend_request_repository.dart';
import '../../datasources/friend/friend_request_remote_datasource.dart';
import '../../models/common_response_model.dart';
import '../../models/friend/friend_request_response_model.dart';

class FriendRequestRepositoryImpl implements FriendRequestRepository {
  final FriendRequestRemoteDatasource remote;

  FriendRequestRepositoryImpl(this.remote);

  @override
  Future<List<FriendRequestResponseModel>> getAllFriendRequestLog() {
    return remote.getAllFriendRequestLog();
  }

  @override
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event) {
    return remote.decideFriendRequest(event);
  }
}
