class ProjectDataModel {
  final String name;
  final String description;
  final String playStoreLink;
  final String appStoreLink;

  ProjectDataModel({
    required this.name,
    required this.description,
    required this.playStoreLink,
    required this.appStoreLink,
  });

  factory ProjectDataModel.fromFirestore(Map<String, dynamic> data) {
    return ProjectDataModel(
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      playStoreLink: data['playStoreLink'] ?? '',
      appStoreLink: data['appStoreLink'] ?? '',
    );
  }
}
