import '../../../domain/entities/friend/frient_request_log_model.dart';
import '../../../domain/repositories/friend/friend_request_log_repository.dart';
import '../../datasources/friend/friend_request_log_datasource.dart';

class FriendRequestLogRepositoryImpl implements FriendRequestLogRepository {
  final FriendRequestLogDatasource remote;

  FriendRequestLogRepositoryImpl(this.remote);

  @override
  Future<List<FrientRequestLogModel>> getAllFriendRequestLog(String userId) {
    return remote.getAllFriendRequestLog(userId);
  }
}
