import 'package:json_annotation/json_annotation.dart';
import 'package:ratatouille/features/recipes/data/model/recipe/recipe_detail_model.dart';
import 'package:ratatouille/features/users/data/model/user_model.dart';
import 'package:ratatouille/features/users/domain/model/social/user_detail.dart';

part 'user_detail_model.g.dart';

@JsonSerializable()
class UserDetailModel {
  final UserModel user;
  final List<RecipeDetailModel> recipes;
  final bool isMe;
  final bool? isFollowing;
  final bool? isFollower;
  final int followersCount;
  final int followingCount;

  const UserDetailModel({
    required this.user,
    required this.recipes,
    required this.isMe,
    required this.isFollowing,
    required this.isFollower,
    required this.followersCount,
    required this.followingCount,
  });

  factory UserDetailModel.fromJson(Map<String, dynamic> json) =>
      _$UserDetailModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailModelToJson(this);

  /// Convert to domain entity
  UserDetail toDomain() {
    return UserDetail(
      user: user.toDomain(),
      recipes: recipes.map((e) => e.toDomain()).toList(),
      isMe: isMe,
      isFollowing: isFollowing,
      isFollower: isFollower,
      followersCount: followersCount,
      followingCount: followingCount,
    );
  }

  /// Convert from domain entity
  factory UserDetailModel.fromDomain(UserDetail userDetail) {
    return UserDetailModel(
      user: UserModel.fromDomain(userDetail.user),
      recipes: userDetail.recipes.map((e) => RecipeDetailModel.fromDomain(e)).toList(),
      isMe: userDetail.isMe,
      isFollowing: userDetail.isFollowing,
      isFollower: userDetail.isFollower,
      followersCount: userDetail.followersCount,
      followingCount: userDetail.followingCount,
    );
  }
}
