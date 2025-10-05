






String normalizeGender(String gender) {

  String lowerGender = gender.toLowerCase().trim();


  List<String> maleValues = ['male', 'ولد'];
  List<String> femaleValues = ['female', 'بنت'];


  if (maleValues.contains(lowerGender)) {
    return 'Male';
  } else if (femaleValues.contains(lowerGender)) {
    return 'Female';
  } else {
    throw ArgumentError('Invalid gender value: $gender');
  }
}
