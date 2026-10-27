class Project {
  final String id;
  final String title;
  final String description;
  final List<String> techStack;

  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.techStack,
  });
}

class Profile {
  final String name;
  final String bio;

  const Profile({required this.name, required this.bio});

  /// Membuat salinan Profile dengan sebagian field diganti.
  Profile copyWith({String? name, String? bio}) =>
      Profile(name: name ?? this.name, bio: bio ?? this.bio);
}
