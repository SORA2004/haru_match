class UserData {
  final String name;
  final String birthDate;
  final String bio;
  final List<String> hobbies;
  final String? gender;

  UserData({
    required this.name,
    required this.birthDate,
    required this.bio,
    required this.hobbies,
    this.gender,
  });

  // Firestore에 저장하기 위해 Map으로 변환하는 메소드
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'birthDate': birthDate,
      'bio': bio,
      'hobbies': hobbies,
      'gender': gender,
    };
  }

  // Firestore 문서로부터 UserData 인스턴스를 생성하는 팩토리 생성자
  factory UserData.fromFirestore(Map<String, dynamic> firestoreData) {
    return UserData(
      name: firestoreData['name'] ?? '',
      birthDate: firestoreData['birthDate'] ?? '',
      bio: firestoreData['bio'] ?? '',
      hobbies: List<String>.from(firestoreData['hobbies'] ?? []),
      gender: firestoreData['gender'],
    );
  }
}


