class OnlineStatusModel {
  final String userId;
  final int status;

  OnlineStatusModel({
    required this.userId,
    required this.status,
  });

  factory OnlineStatusModel.fromJson(Map<String, dynamic> json) {
    return OnlineStatusModel(
      userId: json['userId'] as String,
      status: json['status'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'status': status,
    };
  }
}
