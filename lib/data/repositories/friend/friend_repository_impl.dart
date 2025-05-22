import 'package:tea_talk_mobile/domain/entities/friend/friend_model.dart';

import '../../../domain/repositories/friend/friend_repository.dart';
import '../../datasources/friend/friend_remote_datasource.dart';

class FriendRepositoryImpl implements FriendRepository {
  final FriendDatasource remote;

  FriendRepositoryImpl(this.remote);

  @override
  Future<List<FriendModel>> getFriends() {
    return remote.getFriends();
  }
}
