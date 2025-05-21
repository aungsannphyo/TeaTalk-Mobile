import '../../../data/models/common_response_model.dart';
import '../../entities/friend/frient_request_model.dart';
import '../../events/decide_friend_request_event.dart';

abstract class FriendRequestRepository {
  Future<List<FrientRequestModel>> getAllFriendRequestLog(String userId);
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event);
}
