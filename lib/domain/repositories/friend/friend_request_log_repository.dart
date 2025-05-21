import '../../entities/friend/frient_request_log_model.dart';

abstract class FriendRequestLogRepository {
  Future<List<FrientRequestLogModel>> getAllFriendRequestLog(String userId);
}
