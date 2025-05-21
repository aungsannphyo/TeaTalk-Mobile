enum FriendRequestStatus {
  accepted('ACCEPTED'),
  rejected('REJECTED');

  final String value;
  const FriendRequestStatus(this.value);
}

class DecideFriendRequestEvent {
  final String status;
  final String friendRequestId;

  DecideFriendRequestEvent({
    required this.status,
    required this.friendRequestId,
  });
}
