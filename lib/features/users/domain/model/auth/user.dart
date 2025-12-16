class RatatouilleUser {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final String? coverPictureUrl;
  final String? bio;
  final bool isEmailVerified;
  final int createdAt;
  final int updatedAt;


  const RatatouilleUser({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePictureUrl,
    required this.coverPictureUrl,
    required this.bio,
    required this.isEmailVerified,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isNewUser => name.isEmpty;
}