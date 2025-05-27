import '../../../data/models/common_response_model.dart';
import '../../../data/models/friend/friend_request_response_model.dart';
import '../../events/decide_friend_request_event.dart';

abstract class FriendRequestRepository {
  Future<List<FriendRequestResponseModel>> getAllFriendRequestLog(
      String userId);
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event);
}
