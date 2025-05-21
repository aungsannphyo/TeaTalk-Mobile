class FrientRequestLogModel {
  final String requestId;
  final String senderId;
  final String username;
  final String email;
  final String? profileImage;
  final String createAt;

  FrientRequestLogModel({
    required this.requestId,
    required this.senderId,
    required this.username,
    required this.email,
    required this.createAt,
    this.profileImage,
  });
}
