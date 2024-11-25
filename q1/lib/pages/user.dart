class User {
  final String email;
  final int? age;
  final String? gender;
  final double? bodyWeight;
  final double? bodyHeight;
  final String? bodyType;
  final String? fitnessBackground;
  final double? waistCircumference;
  final double? neckCircumference;
  final List<String>? injuries;
  final List<String>? equipment;
  final List<int>? dumbbellFixedWeight;
  final List<int>? platedWeight;
  final String? medicalConditions;

  User({
    required this.email,
    this.age,
    this.gender,
    this.bodyWeight,
    this.bodyHeight,
    this.bodyType,
    this.fitnessBackground,
    this.waistCircumference,
    this.neckCircumference,
    this.injuries,
    this.equipment,
    this.dumbbellFixedWeight,
    this.platedWeight,
    this.medicalConditions,
  });

  // Convert User object to Map
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'age': age,
      'gender': gender,
      'bodyWeight': bodyWeight,
      'bodyHeight': bodyHeight,
      'bodyType': bodyType,
      'fitnessBackground': fitnessBackground,
      'waistCircumference': waistCircumference,
      'neckCircumference': neckCircumference,
      'injuries': injuries,
      'equipment': equipment,
      'dumbbellFixedWeight': dumbbellFixedWeight,
      'platedWeight': platedWeight,
      'medicalConditions': medicalConditions,
    };
  }

  // Create User object from Map
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] as String,
      age: map['age'] as int?,
      gender: map['gender'] as String?,
      bodyWeight: map['bodyWeight'] as double?,
      bodyHeight: map['bodyHeight'] as double?,
      bodyType: map['bodyType'] as String?,
      fitnessBackground: map['fitnessBackground'] as String?,
      waistCircumference: map['waistCircumference'] as double?,
      neckCircumference: map['neckCircumference'] as double?,
      injuries: map['injuries']?.cast<String>(),
      equipment: map['equipment']?.cast<String>(),
      dumbbellFixedWeight: map['dumbbellFixedWeight']?.cast<int>(),
      platedWeight: map['platedWeight']?.cast<int>(),
      medicalConditions: map['medicalConditions'] as String?,
    );
  }
}
