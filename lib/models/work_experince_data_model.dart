class WorkExperienceDataModel {
  final String company;
  final String position;
  final String duration;
  final String location;
  final List<String> achievements;

  WorkExperienceDataModel({
    required this.company,
    required this.position,
    required this.duration,
    required this.location,
    required this.achievements,
  });

  factory WorkExperienceDataModel.fromFirestore(Map<String, dynamic> data) {
    return WorkExperienceDataModel(
      company: data['company'] ?? '',
      position: data['position'] ?? '',
      duration: data['duration'] ?? '',
      location: data['location'] ?? '',
      achievements:
          (data['achievements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
    );
  }
}
