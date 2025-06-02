class UpdateUserNameEvent {
  final String username;

  UpdateUserNameEvent({required this.username});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
    };
  }
}
