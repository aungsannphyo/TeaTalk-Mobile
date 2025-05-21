class CommonResponseModel {
  final String message;

  CommonResponseModel({
    required this.message,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonResponseModel(
      message: json['message'],
    );
  }
}
