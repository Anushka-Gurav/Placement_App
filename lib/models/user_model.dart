class UserModel {
  final String name;
  final String email;
  final String role;

  final String branch;
  final String year;
  final String cgpa;

  final Map<String, String> codingProfiles;

  const UserModel({
    required this.name,
    required this.email,
    required this.role,
    required this.branch,
    required this.year,
    required this.cgpa,
    this.codingProfiles = const {},
  });
}