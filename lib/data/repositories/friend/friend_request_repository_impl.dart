import 'package:tea_talk_mobile/data/models/common_response_model.dart';

import 'package:tea_talk_mobile/domain/events/decide_friend_request_event.dart';

import '../../../domain/entities/friend/frient_request_model.dart';
import '../../../domain/repositories/friend/friend_request_repository.dart';
import '../../datasources/friend/friend_request_remote_datasource.dart';

class FriendRequestRepositoryImpl implements FriendRequestRepository {
  final FriendRequestRemoteDatasource remote;

  FriendRequestRepositoryImpl(this.remote);

  @override
  Future<List<FrientRequestModel>> getAllFriendRequestLog(String userId) {
    return remote.getAllFriendRequestLog(userId);
  }

  @override
  Future<CommonResponseModel> decideFriendRequest(
      DecideFriendRequestEvent event) {
    return remote.decideFriendRequest(event);
  }
}
