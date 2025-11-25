class PersonalInfoModel {
  final String firstName;
  final String lastName;
  final String title;
  final String location;
  final String bio;
  final String phone;
  final String email;
  final String linkedIn;
  final List<dynamic> topSkills;

  PersonalInfoModel({
    required this.firstName,
    required this.lastName,
    required this.title,
    required this.location,
    required this.bio,
    required this.phone,
    required this.email,
    required this.linkedIn,
    required this.topSkills,
  });

  String get fullName => '$firstName $lastName';

  factory PersonalInfoModel.fromFirestore(Map<String, dynamic> data) {
    return PersonalInfoModel(
      firstName: data['first_name'] ?? data['firstName'] ?? '',
      lastName: data['last_name'] ?? data['lastName'] ?? '',
      title: data['title'] ?? '',
      location: data['location'] ?? '',
      bio: data['bio'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'] ?? '',
      linkedIn: data['linkedIn'] ?? '',
      topSkills: data['topSkills'] ?? [],
    );
  }
}
