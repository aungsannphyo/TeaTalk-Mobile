import '../../../data/models/common_response_model.dart';
import '../../../data/models/friend/friend_request_response_model.dart';
import '../../events/decide_friend_request_event.dart';
import '../../repositories/friend/friend_request_repository.dart';

class FriendRequestUsecase {
  final FriendRequestRepository repository;

  FriendRequestUsecase(this.repository);

  Future<List<FriendRequestResponseModel>> getAllFriendRequestLog() {
    return repository.getAllFriendRequestLog();
  }

  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event) {
    return repository.decideFriendRequest(event);
  }
}
