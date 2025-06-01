enum Gender { male, female, other }

// Convert Gender enum to API string
String genderToApiString(Gender gender) {
  switch (gender) {
    case Gender.male:
      return "MALE";
    case Gender.female:
      return "FEMALE";
    case Gender.other:
      return "OTHER";
  }
}

// Convert API string to Gender enum
Gender genderFromApiString(String apiString) {
  switch (apiString.toUpperCase()) {
    case "MALE":
      return Gender.male;
    case "FEMALE":
      return Gender.female;
    case "OTHER":
      return Gender.other;
    default:
      throw Exception("Unknown gender string: $apiString");
  }
}

String getGenderLabel(Gender gender) {
  switch (gender) {
    case Gender.male:
      return 'Male';
    case Gender.female:
      return 'Female';
    case Gender.other:
      return 'Other';
  }
}
