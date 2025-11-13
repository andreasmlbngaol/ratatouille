import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:ratatouille/features/users/domain/model/auth/user.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final String? profilePictureUrl;

  @HiveField(4)
  final String? coverPictureUrl;

  @HiveField(5)
  final String? bio;

  @HiveField(6)
  final bool isEmailVerified;

  @HiveField(7)
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.profilePictureUrl,
    this.coverPictureUrl,
    this.bio,
    required this.isEmailVerified,
    required this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  // Convert to domain entity
  User toDomain() {
    return User(
      id: id,
      email: email,
      name: name,
      profilePictureUrl: profilePictureUrl,
      coverPictureUrl: coverPictureUrl,
      bio: bio,
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
    );
  }

  // Convert from domain entity
  factory UserModel.fromDomain(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      profilePictureUrl: user.profilePictureUrl,
      coverPictureUrl: user.coverPictureUrl,
      bio: user.bio,
      isEmailVerified: user.isEmailVerified,
      createdAt: user.createdAt,
    );
  }

}