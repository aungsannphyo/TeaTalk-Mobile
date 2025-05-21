import '../../../data/models/common_response_model.dart';
import '../../entities/friend/frient_request_model.dart';
import '../../events/decide_friend_request_event.dart';
import '../../repositories/friend/friend_request_repository.dart';

class FriendRequestUsecase {
  final FriendRequestRepository repository;

  FriendRequestUsecase(this.repository);

  Future<List<FrientRequestModel>> getAllFriendRequestLog(String userId) {
    return repository.getAllFriendRequestLog(userId);
  }

  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event) {
    return repository.decideFriendRequest(event);
  }
}
