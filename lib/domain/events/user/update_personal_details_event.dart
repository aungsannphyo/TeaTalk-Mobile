import '../../../utils/gender.dart';

class UpdatePersonalDetailsEvent {
  final Gender gender;
  final String dateOfBirth;
  final String bio;

  UpdatePersonalDetailsEvent({
    required this.gender,
    required this.dateOfBirth,
    required this.bio,
  });

  Map<String, dynamic> toJson() {
    return {
      "gender": genderToApiString(gender),
      "dateOfBirth": dateOfBirth,
      "bio": bio,
    };
  }
}
