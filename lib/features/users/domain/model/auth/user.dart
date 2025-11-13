class User {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? coverPictureUrl;
  final String? bio;
  final bool isEmailVerified;
  final DateTime createdAt;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.coverPictureUrl,
    required this.bio,
    required this.isEmailVerified,
    required this.createdAt
  });

  bool get isNewUser => name.isEmpty;
}