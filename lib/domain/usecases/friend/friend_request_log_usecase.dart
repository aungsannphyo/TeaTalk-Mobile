import '../../entities/friend/frient_request_log_model.dart';
import '../../repositories/friend/friend_request_log_repository.dart';

class FriendRequestLogUsecase {
  final FriendRequestLogRepository repository;

  FriendRequestLogUsecase(this.repository);

  Future<List<FrientRequestLogModel>> getAllFriendRequestLog(String userId) {
    return repository.getAllFriendRequestLog(userId);
  }
}
